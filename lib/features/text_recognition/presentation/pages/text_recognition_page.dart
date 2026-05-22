import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/text_recognition_bloc.dart';
import '../bloc/text_recognition_event.dart';
import '../bloc/text_recognition_state.dart';
import '../widgets/image_preview_card.dart';
import '../widgets/recognized_text_card.dart';

class TextRecognitionPage extends StatelessWidget {
  const TextRecognitionPage({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      if (!context.mounted) return;
      context.read<TextRecognitionBloc>().add(
            TextRecognitionImageSelected(imagePath: pickedFile.path),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
          ).createShader(bounds),
          child: const Text(
            'Smart OCR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () {
              context
                  .read<TextRecognitionBloc>()
                  .add(const TextRecognitionClearRequested());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<TextRecognitionBloc, TextRecognitionState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildContentForState(context, state),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContentForState(
      BuildContext context, TextRecognitionState state) {
    return switch (state) {
      TextRecognitionInitial() => ImagePreviewCard(
          imagePath: null,
          onTapGallery: () => _pickImage(context, ImageSource.gallery),
          onTapCamera: () => _pickImage(context, ImageSource.camera),
        ),
      TextRecognitionLoading() => const _LoadingView(),
      TextRecognitionSuccess(:final imagePath, :final result) => Column(
          children: [
            ImagePreviewCard(
              imagePath: imagePath,
              onTapGallery: () => _pickImage(context, ImageSource.gallery),
              onTapCamera: () => _pickImage(context, ImageSource.camera),
            ),
            const SizedBox(height: 20),
            RecognizedTextCard(
              recognizedText: result.recognizedText,
              lines: result.lines,
            ),
          ],
        ),
      TextRecognitionError(:final errorMessage) => _ErrorView(
          errorMessage: errorMessage,
          onRetry: () => context
              .read<TextRecognitionBloc>()
              .add(const TextRecognitionClearRequested()),
        ),
    };
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE100FF)),
          ),
          SizedBox(height: 20),
          Text(
            'Analyzing Image with Google AI...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
        const SizedBox(height: 16),
        const Text(
          'Ops! Scanning Failed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7F00FF),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Try Again', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

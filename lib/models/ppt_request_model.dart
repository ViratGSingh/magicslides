class PPTRequestModel {
  final String topic;
  final String email;
  final String accessId;
  final String template;
  final String? extraInfoSource;
  final int slideCount;
  final String language;
  final bool aiImages;
  final bool imageForEachSlide;
  final bool googleImage;
  final bool googleText;
  final String model; // "gpt-4" or "gpt-3.5"
  final String presentationFor;
  final Map<String, dynamic>? watermark;

  PPTRequestModel({
    required this.topic,
    required this.email,
    required this.accessId,
    this.template = 'bullet-point1',
    this.extraInfoSource,
    this.slideCount = 10,
    this.language = 'en',
    this.aiImages = false,
    this.imageForEachSlide = true,
    this.googleImage = false,
    this.googleText = false,
    this.model = 'gpt-3.5',
    this.presentationFor = 'student',
    this.watermark,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'topic': topic,
      'email': email,
      'accessId': accessId,
      'template': template,
      'language': language,
      'slideCount': slideCount,
      'aiImages': aiImages,
      'imageForEachSlide': imageForEachSlide,
      'googleImage': googleImage,
      'googleText': googleText,
      'model': model,
      'presentationFor': presentationFor,
    };

    if (extraInfoSource != null) {
      data['extraInfoSource'] = extraInfoSource;
    }
    if (watermark != null) {
      data['watermark'] = watermark;
    }

    return data;
  }
}

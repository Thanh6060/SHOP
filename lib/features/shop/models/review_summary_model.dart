class ReviewSummaryModel {
  final String productId;
  final double positiveRate;
  final double neutralRate;
  final double negativeRate;
  final String aiSummary;
  final List<AspectTagModel> aspects;

  ReviewSummaryModel({
    required this.productId,
    required this.positiveRate,
    required this.neutralRate,
    required this.negativeRate,
    required this.aiSummary,
    required this.aspects,
  });

  factory ReviewSummaryModel.fromFirestore(Map<String, dynamic> json) {
    return ReviewSummaryModel(

      productId: json['productId'] ?? json['product_id'] ?? '',
      positiveRate: (json['positiveRate'] ?? json['positive_rate'] ?? 0.0).toDouble(),
      neutralRate: (json['neutralRate'] ?? json['neutral_rate'] ?? 0.0).toDouble(),
      negativeRate: (json['negativeRate'] ?? json['negative_rate'] ?? 0.0).toDouble(),
      aiSummary: json['aiSummary'] ?? json['ai_summary'] ?? 'Chưa có tóm tắt từ AI.',
      aspects: (json['aspects'] as List? ?? [])
          .map((e) => AspectTagModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class AspectTagModel {
  final String label;
  final String type;
  final int count;

  AspectTagModel({required this.label, required this.type, required this.count});

  factory AspectTagModel.fromJson(Map<String, dynamic> json) {
    return AspectTagModel(
      label: json['label'] ?? '',
      type: json['type'] ?? 'neutral',
      count: json['count'] ?? 0,
    );
  }
}
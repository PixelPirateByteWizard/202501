enum RiskLevel { low, medium, high }

class AIReport {
  final String summary;
  final RiskLevel riskLevel;
  final String pros;
  final String cons;

  AIReport({
    required this.summary,
    required this.riskLevel,
    required this.pros,
    required this.cons,
  });

  factory AIReport.fromJson(Map<String, dynamic> json) {
    return AIReport(
      summary: json['summary'] ?? '',
      riskLevel: RiskLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['riskLevel'],
        orElse: () => RiskLevel.medium,
      ),
      pros: json['pros'] ?? '',
      cons: json['cons'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'riskLevel': riskLevel.toString().split('.').last,
      'pros': pros,
      'cons': cons,
    };
  }
}
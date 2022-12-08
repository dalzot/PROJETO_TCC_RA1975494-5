class RateModel {
  int rateService,
      ratePrice,
      rateProfessional;
  
  RateModel({
    this.rateService = 0,
    this.ratePrice = 0,
    this.rateProfessional = 0,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) => RateModel(
    rateService: json['rateService'],
    ratePrice: json['ratePrice'],
    rateProfessional: json['rateProfessional'],
  );

  static List<RateModel> fromList(List<dynamic> l) {
    return List<RateModel>.from(l.map((model)=> RateModel.fromJson(model)));
  }

  static List<Map<String, dynamic>> toList(List<RateModel> l) {
    return List<Map<String, dynamic>>.from(l.map((model)=> model.toJson()));
  }

  Map<String, dynamic> toJson() => {
    'rateService': rateService,
    'ratePrice': ratePrice,
    'rateProfessional': rateProfessional,
  };
}
class SearchCepModel {
  String zipCode;
  String publicPlace;
  String complement;
  String district;
  String locality;
  String state;
  String? ibge;
  String? gia;
  String? ddd;
  String? siafi;

  SearchCepModel({
    required this.zipCode,
    required this.publicPlace,
    required this.complement,
    required this.district,
    required this.locality,
    required this.state,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
  });

  factory SearchCepModel.fromJson(Map<String, dynamic> json) =>
      SearchCepModel(
        zipCode: json["cep"],
        publicPlace: json["logradouro"],
        complement: json["complemento"],
        district: json["bairro"],
        locality: json["localidade"],
        state: json["uf"],
        ibge: json["ibge"],
        gia: json["gia"],
        ddd: json["ddd"],
        siafi: json["siafi"],
      );
}

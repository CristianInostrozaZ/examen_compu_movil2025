class Proveedor {
  final int providerId;
  final String providerName;
  final String providerLastName;
  final String providerMail;
  final String providerState;

  Proveedor({
    required this.providerId,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
    }

  factory Proveedor.fromMap(Map<String, dynamic> map) {
    
    final dynamic rawId = map['provider_id'] ??
        map['id'] ??
        map['providerId'] ??
        map['providerid'] ??
        map['id_provider'] ??
        map['idProveedor'];

    return Proveedor(
      providerId: _toInt(rawId),
      providerName: (map['provider_name'] ?? map['name'] ?? '').toString(),
      providerLastName:
          (map['provider_last_name'] ?? map['last_name'] ?? '').toString(),
      providerMail:
          (map['provider_mail'] ?? map['mail'] ?? map['email'] ?? '').toString(),
      providerState: (map['provider_state'] ?? map['state'] ?? 'Activo').toString(),
    );
  }
}

List<Proveedor> proveedoresFromJson(List<dynamic> list) =>
    list.map((e) => Proveedor.fromMap((e as Map).cast<String, dynamic>())).toList();

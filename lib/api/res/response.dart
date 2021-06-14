class Response {

  int status;
  Map<String, dynamic> body;

  Response(this.status, this.body);

  factory Response.fromJson(Map<String, dynamic> json) {

    return Response(json['status'], json['body']);

  }

}

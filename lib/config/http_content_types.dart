enum HttpContentType {
  xWwwFormUrlencoded('application/x-www-form-urlencoded'),
  json('application/json'),
  octetStream('octet-stream'),
  ;

  final String value;

  const HttpContentType(this.value);
}

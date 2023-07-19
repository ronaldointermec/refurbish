class Global {

  // static final URL_REFURBISH = 'http://BR92LT88H95N3:3333/refurbish'; //Homologação
  // static final URL_REFURBISH = 'http://HIC033312:8096/refurbish'; //Produção
  static final URL_REFURBISH = 'http://BR92LT88H95N3:8096/refurbish'; //Produção
  static final URL_SIP = 'http://hic032553:8080/api';
  //static final URL_SSO =   'https://authn.honeywell.com/as/authorization.oauth2?client_id=Client_336&response_type=code&redirect_uri=https://oauthapp.honeywell.com';
  static final URL_SSO =   'http://hic032553:8080/api/Auth/oauth2?clientId=Client_';


  static final Map<String, String> HEADERS = {
    'Access-Control-Allow-Methods': '*',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': '*',
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Credentials': 'true'
  };
  static bool podeAdicionarPN = false;
  static bool isEmprestimo = false;
  static bool podeConsultarRequisicao = false;
  static final String version = '1.0.51\n2023-02-08';
}

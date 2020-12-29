class APIPath {
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';
  static String homeCarousel() => 'home/Garapin2020/carousel';
  static String homeBody() => 'home/Garapin2020/body/description';
  static String userCustom(String uid, String fcid) =>
      'users/$uid/freecustom/$fcid';
  static String userCustoms(String uid) => 'users/$uid/freecustom/';
  static String imagesPath(String uid, String fcID) =>
      'users/$uid/freecustom/$fcID/images';

  static String imagePath(String uid, String fcID, String imageID) =>
      //'users/$uid/freecustom/$fcID/images/$imageID';
      'users/$uid/freecustom/$fcID/images/$imageID';
}

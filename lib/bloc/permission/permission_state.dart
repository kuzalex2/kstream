
part of 'permission_cubit.dart';




enum MyPermissionStatus {
  unknown,
  undetermined,
  denied,
  granted,
  restricted,
  limited,
  permanentlyDenied,
}

extension MyPermissionStatusGetters on MyPermissionStatus {


  bool get isUnknown => this == MyPermissionStatus.unknown;

  bool get isUndetermined => this == MyPermissionStatus.undetermined;

  bool get isDenied => this == MyPermissionStatus.denied  || this == MyPermissionStatus.permanentlyDenied || this == MyPermissionStatus.restricted;

  bool get isGranted => this == MyPermissionStatus.granted || this == MyPermissionStatus.limited;

  // bool get isRestricted => this == MyPermissionStatus.restricted;
  // bool get isLimited => this == MyPermissionStatus.limited;

  static MyPermissionStatus create(PermissionStatus status){
    switch(status){
      case PermissionStatus.denied: return MyPermissionStatus.denied;
      case PermissionStatus.granted: return MyPermissionStatus.granted;
      case PermissionStatus.restricted: return MyPermissionStatus.restricted;
      case PermissionStatus.limited: return MyPermissionStatus.limited;
      case PermissionStatus.permanentlyDenied: return MyPermissionStatus.permanentlyDenied;
    }

  }
}

class PermissionState extends Equatable {

  final MyPermissionStatus camStatus;
  final MyPermissionStatus micStatus;

  const PermissionState( {
    required this.camStatus,
    required this.micStatus,
  });

  static const unknown = PermissionState(
      micStatus: MyPermissionStatus.unknown,
      camStatus:  MyPermissionStatus.unknown,
  );

  PermissionState copyWith({
    MyPermissionStatus? camStatus,
    MyPermissionStatus? micStatus,

  }) {
    return PermissionState(
      camStatus: camStatus ?? this.camStatus,
      micStatus: micStatus ?? this.micStatus,
    );
  }

  @override
  List<Object> get props => [
    camStatus,
    micStatus,
    // isPermissionStatusKnown,
  ];
}



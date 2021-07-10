import 'modals.dart';

class CurrentUser {
  CurrentUser({
    this.departmentName,
    this.name,
    this.imageUrl,
    this.id,
  });

  factory CurrentUser.fromMap(Map data) {
    return CurrentUser(
      id: data['ID'].toString(),
      name: data['Name'],
      departmentName: data['Department'],
      imageUrl: data['Image'],
    );
  }
  final String id, name, departmentName;
  bool isCandidate = false;
  String candidateManifest, imageUrl, later;

  bool isVoted = false;

  Map mapManifest = {
    'ManifestCollage': {'Name': 'null', 'Candidates': <Candidate>[]},
    'Manifestdepartment': {'Name': 'null', 'Candidates': <Candidate>[]},
    'Favert': {'Name': []},
  };
  List<int> getCandidateID() {
    List<int> IDs = <int>[];
    mapManifest['Manifestdepartment']['Candidates'].forEach((element) {
      IDs.add(int.parse(element.id));
    });
    return IDs;
  }

  void addToF(String name) {
    if (mapManifest['Favert']['Name'].contains(name)) return;
    mapManifest['Favert']['Name'].add(name);
  }

  void addManifestdepartment(String name) {
    mapManifest['Manifestdepartment']['Name'] = name;
  }

  void addManifestCollage(String name) {
    mapManifest['Manifestdepartment']['Name'] = name;
  }

  void setCandidatesdepartment(List<Candidate> value) {
    mapManifest['Manifestdepartment']['Candidates'] = value;
  }

  void setCandidatesCollage(List<Candidate> value) {
    mapManifest['ManifestCollage']['Candidates'] = value;
  }
}

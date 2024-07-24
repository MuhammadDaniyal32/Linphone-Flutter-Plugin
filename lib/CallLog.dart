class CallLogs {
  CallLogs(
     this.callHistory,
  );
  late final List<CallHistory> callHistory;

  CallLogs.fromJson(Map<String, dynamic> json){
    callHistory = List.from(json['callHistoryList']).map((e)=>CallHistory.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['callHistoryList'] = callHistory.map((e)=>e.toJson()).toList();
    return data;
  }
}

class CallHistory {
  CallHistory({
    required this.date,
    required this.duration,
    required this.number,
    required this.status,
  });
  late final int date;
  late final int duration;
  late final String number;
  late final String status;

  CallHistory.fromJson(Map<String, dynamic> json){
    date = json['date'];
    duration = json['duration'];
    number = json['number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['duration'] = duration;
    data['number'] = number;
    data['status'] = status;
    return data;
  }
}
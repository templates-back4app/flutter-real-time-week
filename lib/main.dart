import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'Your_App_ID_Here';
  const keyClientKey = 'Your_Client_Key_Here';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey,
      liveQueryUrl: 'wss://Your_Live_Query_URL_Here',
      debug: true,
      autoSendSessionId: true);

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LiveQuery liveQuery = LiveQuery();
  QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject("Person"));

  List<ParseObject> results = <ParseObject> [];
  

  void startLiveQuery() async {
    Subscription subscription = await liveQuery.client.subscribe(query);

    subscription.on(LiveQueryEvent.create, (value){
      debugPrint("OBJECT CREATED: $value");

      setState((){
        results.add(value);
      });
    });

    subscription.on(LiveQueryEvent.update, (value){
      debugPrint("OBJECT UPDATED: $value");
    });

    subscription.on(LiveQueryEvent.delete, (value){
      debugPrint("OBJECT DELETED: $value");
    });

    subscription.on(LiveQueryEvent.enter, (value){
      debugPrint("OBJECT ENTERED: $value");
    });

    subscription.on(LiveQueryEvent.leave, (value){
      debugPrint("OBJECT LEFT: $value");
    });
  }

  @override
  void initState(){
    super.initState();
    startLiveQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: Text("Real Time Week"),
                backgroundColor: Colors.blueAccent,
                centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 8,
            ),
            Text(
              'Result List: ${results.length}',
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                      return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)), 
                            child: Text(results[index].toString()
                          ),
                      );
                  }
              ),
            )
          ]
        ),
      )
    );
  }
}
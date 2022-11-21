
import 'global.dart' as global;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(title: 'Caffe Latte'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textController;
  final ScrollController _controllerOne = ScrollController();
  final ScrollController _controllerTwo = ScrollController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode myFocusNode;

  late bool isButtonSaleDisabled; //Кнопка продажи заказа

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    myFocusNode = FocusNode();
    isButtonSaleDisabled = false;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  getClient() async {
    dynamic myResponse;

    try {
      const url = 'http://10.0.0.3/baza_sklad_center/hs/kitchen/v1/getdata';
      var barcodeClient = global.barcodeClientAfterScanning;
      var jsonPost = '{"method":"get_client", "authorization":"38597848-s859-f588-g5568-1245986532sd", "phone":"380988547870", "barcode":"$barcodeClient"}';
      const headersPost = {
        'Content-Type':'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS'};
      var response = await http.post(Uri.parse(url), headers: headersPost, body: jsonPost);

      myResponse = json.decode(response.body);

      // Если нашли клиента, то установим его на форме
      if (myResponse['result'] == true){
        setState(() {
          global.barcodeClient = global.barcodeClientAfterScanning;
          global.nameClient = myResponse['client'];
          global.textInfo = myResponse['client'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Клієнта на сервері не знайдено!'),
                duration: Duration(seconds: 3),
                backgroundColor: Colors.orangeAccent));
        global.barcodeClient = '';
        global.nameClient = '';
        global.textInfo = global.textScanBarcode;
        return;
      }
    } catch (error) {
       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
               behavior: SnackBarBehavior.floating,
               content: Text('Помилка пошуку клієнта на сервері!'
                   '$error'),
               duration: const Duration(seconds: 5),
               backgroundColor: Colors.orangeAccent));
       global.barcodeClient = '';
       global.nameClient = '';
       global.textInfo = global.textScanBarcode;
     }
   }

  sumOrderDoubleToString() {
    var num1 = global.orderSum;
    var f = NumberFormat("##0.00", "en_US");
    return (f.format(num1).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('COTTE-LATTE', style: TextStyle(color: Colors.orangeAccent)),
        backgroundColor: const Color(0xFF1C2428),
        automaticallyImplyLeading: true,
        actions: const [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: const Color(0xFF080E12),
      body: VisibilityDetector(
        onVisibilityChanged: (VisibilityInfo info) {
          //var visible = info.visibleFraction > 0;
        },
        key: const Key('visible-detector-key'),
        child: BarcodeKeyboardListener(
          onBarcodeScanned: (barcode) {
            setState(() {
              global.barcodeClientAfterScanning = barcode;
              global.textInfo = 'Пошук клієнта...';
              getClient();
            });
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Material(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: 770,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2428),
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: const Color(0xFF59656B),
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      debugPrint('Тест');
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
                                      child: Icon(
                                        FontAwesomeIcons.cat,
                                        color: Color(0xFFFAFAFA),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          2, 2, 2, 2),
                                      child:Center(
                                        child: Text(
                                          global.textInfo.toString(),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Material(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: 489,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C2428),
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: const Color(0xFF59656B),
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                    child: Text(
                                      'Сума замовлення: ',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: Text(
                                      sumOrderDoubleToString(),
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orangeAccent),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                    child: Text(
                                      ' грн',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orangeAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 5, 0),
                          child: Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  width: 400,
                                  height:
                                       MediaQuery.of(context).size.height - 310,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C2428),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFF59656B),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 5, 5, 10),
                                          child: Scrollbar(
                                            controller: _controllerOne,
                                            child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: global.listItemMenu.length,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                final global.ListItemMenu itemMenu =
                                                    global.listItemMenu[index];

                                                // Строка товара в списке заказа
                                                return ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      } else {
                                                        global.orderSum = global.orderSum - itemMenu.price;
                                                        global.listItemMenu
                                                            .removeAt(index);
                                                      }
                                                    });
                                                  },
                                                  title: Text(
                                                      itemMenu.name.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 30,
                                                          color:
                                                              Colors.orangeAccent)),
                                                  subtitle: Text(
                                                        '' +
                                                        itemMenu.count.toString() +
                                                        ' шт x ' +
                                                        itemMenu.sum.toString() +
                                                        ' = ' +
                                                        itemMenu.sum.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.grey),
                                                  ),
                                                  trailing: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 20,
                                                  ),
                                                  dense: false,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Container(
                                width: 400,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C2428),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF59656B),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                  5, 5, 5, 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize:
                                                          const Size(180, 80),
                                                      primary: Colors.green),
                                                  onPressed: () async {

                                                    // Проверка штрихкода
                                                    if (global.barcodeClient.isEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                              behavior: SnackBarBehavior.floating,
                                                              content: Text(global.textScanBarcode),
                                                              duration: Duration(seconds: 1),
                                                              backgroundColor: Colors.orangeAccent));
                                                      return;
                                                    }

                                                    // Проверка списка товаров
                                                    if (global.listItemMenu.isEmpty) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                              behavior: SnackBarBehavior.floating,
                                                              content: Text('Замовлення порожнє!'),
                                                              duration: Duration(seconds: 1),
                                                              backgroundColor: Colors.orangeAccent));
                                                      return;
                                                    }

                                                    // Если кнопка выключена, значит идет продажа, иначе
                                                    if (isButtonSaleDisabled) {
                                                        return;
                                                    } else {
                                                      setState(() {
                                                        isButtonSaleDisabled = true;
                                                        global.textInfo = 'Створення замовлення...';
                                                      });
                                                    }

                                                    //
                                                    dynamic myResponse;

                                                     try {
                                                      const url = 'http://10.0.0.3/baza_sklad_center/hs/kitchen/v1/getdata';
                                                      var itemsMenu = jsonEncode(global.listItemMenu.toList());
                                                      var barcodeClient = global.barcodeClient;
                                                      var jsonPost = '{"method":"create_order", "authorization":"38597848-s859-f588-g5568-1245986532sd", "phone":"380988547870", "barcode":"$barcodeClient","itemsMenu":$itemsMenu}';
                                                      const headersPost = {
                                                        'Content-Type':'application/json',
                                                        'Access-Control-Allow-Origin': '*',
                                                        'Access-Control-Allow-Credentials': 'true',
                                                        'Access-Control-Allow-Methods': 'POST, OPTIONS'};
                                                      var response = await http.post(Uri.parse(url), headers: headersPost, body: jsonPost);

                                                      myResponse = json.decode(response.body);

                                                      if (myResponse['result'] == true){

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                                behavior: SnackBarBehavior.floating,
                                                                content: Text('Замовлення успішно створено!'),
                                                                duration: Duration(seconds: 1),
                                                                backgroundColor: Colors.green));//
                                                          setState(() {
                                                            isButtonSaleDisabled = false;

                                                            var nameClient = global.nameClient.toString();
                                                            var sumClient = 0.00;
                                                            var orderClient = '';

                                                            for (var itemMenu in global.listItemMenu) {
                                                              sumClient = sumClient + itemMenu.price;
                                                              orderClient = orderClient + '\n' + itemMenu.name + ' ' + itemMenu.sum;
                                                            }

                                                            // Запись в историю заказов
                                                            global.ListItemMenuHistory
                                                            listItemMenuHistory =
                                                            global.ListItemMenuHistory(nameClient,sumClient,orderClient.trim(),DateTime.now());
                                                            global.listItemMenuHistory
                                                                .add(listItemMenuHistory);
                                                            global.listItemMenuHistory.sort((a, b) => b.date.compareTo(a.date));
                                                            // Сортировка списка истории заказов

                                                            // Очистка окна
                                                            global.listItemMenu.clear();
                                                            global.orderSum = 0.00;
                                                            global.barcodeClient = '';
                                                            global.nameClient = '';
                                                            global.textInfo = global.textScanBarcode;
                                                          });// setState

                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(
                                                                behavior: SnackBarBehavior.floating,
                                                                content: Text('Помилка створення замовлення на сервері!'),
                                                                duration: Duration(seconds: 3),
                                                                backgroundColor: Colors.orangeAccent));
                                                        setState(() {
                                                          isButtonSaleDisabled = false;
                                                        });
                                                        return;
                                                      }
                                                    } catch (error) {

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                           SnackBar(
                                                               behavior: SnackBarBehavior.floating,
                                                               content: Text('Помилка обробки замовлення на сервері! \n '
                                                                   '$error'),
                                                               duration: const Duration(seconds: 5),
                                                               backgroundColor: Colors.orangeAccent));

                                                      setState(() {
                                                        isButtonSaleDisabled = false;
                                                      }); // setState
                                                     }
                                                  },
                                                  child: const Text('Оплатити',
                                                      style: TextStyle(fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white))
                                              ),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize:
                                                          const Size(180, 80),
                                                      primary:
                                                          Colors.red),
                                                  onPressed: () {
                                                    setState(() {
                                                      global.listItemMenu.clear();
                                                      global.orderSum = 0.00;
                                                      global.barcodeClient = '';
                                                      global.nameClient = '';
                                                      global.textInfo = global.textScanBarcode;
                                                    });
                                                  },
                                                  child: const Text('Очистити',
                                                      style: TextStyle(fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white)))
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 5, 0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            // Правая рамка с меню
                            child: Container(
                              width: 860,
                              height: MediaQuery.of(context).size.height-203,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2428),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFF59656B),
                                  width: 1,
                                ),
                              ),
                              child: DefaultTabController(
                                length: 3,
                                initialIndex: 0,
                                child: Column(
                                  children: [
                                    const TabBar(
                                      labelColor: Color(0xFFFAFAFA),
                                      indicatorColor: Color(0xFFA4ABB0),
                                      indicatorWeight: 2,
                                      tabs: [
                                        Tab(
                                          text: 'Кофе-машина',
                                          icon: Icon(
                                            Icons.local_drink_outlined,
                                            color: Color(0xFFFAFAFA),
                                            size: 20,
                                          ),
                                        ),
                                        Tab(
                                          text: 'Холодильник',
                                          icon: Icon(
                                            Icons.stay_current_portrait_sharp,
                                            color: Color(0xFFFAFAFA),
                                            size: 20,
                                          ),
                                        ),
                                        Tab(
                                          text: 'История заказов',
                                          icon: Icon(
                                            Icons.stay_current_portrait_sharp,
                                            color: Color(0xFFFAFAFA),
                                            size: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          // Вкладка Кофе-машина
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 5, 5, 10),
                                            child: GridView(
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 5,
                                                childAspectRatio: 1,
                                              ),
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (isButtonSaleDisabled) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      global.ListItemMenu
                                                          listItem =
                                                          global.ListItemMenu(
                                                              '000000152',
                                                              'Кава',
                                                              '1',
                                                              8.00,
                                                              '8.00 грн');
                                                      global.listItemMenu
                                                          .add(listItem);
                                                      global.orderSum =
                                                          global.orderSum +
                                                              listItem.price;
                                                    });
                                                  },
                                                  child: const CardMenu(
                                                      codeCard: '000000152',
                                                      nameCard: 'Кава',
                                                      priceCard: '8.00',
                                                      sumCard: '8.00 грн'),
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000158',
                                                                'Вершки',
                                                                '1',
                                                                2,
                                                                '2.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000158',
                                                        nameCard: 'Вершки',
                                                        priceCard: '2.00',
                                                        sumCard: '2.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000269',
                                                                'Латте',
                                                                '1',
                                                                17.00,
                                                                '17.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000269',
                                                        nameCard: 'Латте',
                                                        priceCard: '17.00',
                                                        sumCard: '17.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000268',
                                                                'Капучіно',
                                                                '1',
                                                                14.00,
                                                                '14.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000268',
                                                        nameCard: 'Капучіно',
                                                        priceCard: '14.00',
                                                        sumCard: '14.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000334',
                                                                'Флет Вайт',
                                                                '1',
                                                                17.00,
                                                                '17.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000334',
                                                        nameCard: 'Флет Вайт',
                                                        priceCard: '17.00',
                                                        sumCard: '17.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000333',
                                                                'Маккіато',
                                                                '1',
                                                                9.00,
                                                                '9.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000333',
                                                        nameCard: 'Маккіато',
                                                        priceCard: '9.00',
                                                        sumCard: '9.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000176',
                                                                'Чай',
                                                                '1',
                                                                4.00,
                                                                '4.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000176',
                                                        nameCard: 'Чай',
                                                        priceCard: '4.00',
                                                        sumCard: '4.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000054',
                                                                'Молоко',
                                                                '1',
                                                                6.00,
                                                                '6.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000054',
                                                        nameCard: 'Молоко',
                                                        priceCard: '6.00',
                                                        sumCard: '6.00 грн')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000175',
                                                                'Смаколики',
                                                                '1',
                                                                11.00,
                                                                '11.00 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenu(
                                                        codeCard: '000000175',
                                                        nameCard: 'Смаколики',
                                                        priceCard: '11.00',
                                                        sumCard: '6.00 грн')),
                                              ],
                                            ),
                                          ),
                                          // Вкладка Холодильник
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 5, 5, 15),
                                            child: GridView(
                                              padding: EdgeInsets.zero,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5,
                                                crossAxisSpacing: 20,
                                                mainAxisSpacing: 5,
                                                childAspectRatio: 1,
                                              ),
                                              scrollDirection: Axis.vertical,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (isButtonSaleDisabled) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      global.ListItemMenu
                                                          listItem =
                                                          global.ListItemMenu(
                                                              '000000567',
                                                              'Coca cola',
                                                              '1',
                                                              14.20,
                                                              '14.20 грн');
                                                      global.listItemMenu
                                                          .add(listItem);
                                                      global.orderSum =
                                                          global.orderSum +
                                                              listItem.price;
                                                    });
                                                  },
                                                  child: const CardMenuBottle(
                                                      codeCard: '000000567',
                                                      nameCard: 'Coca cola'),
                                                ),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000568',
                                                                'Fanta',
                                                                '1',
                                                                14.20,
                                                                '14.20 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000568',
                                                        nameCard: 'Fanta')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000569',
                                                                'Sprite',
                                                                '1',
                                                                14.20,
                                                                '14.20 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000569',
                                                        nameCard: 'Sprite')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000570',
                                                                'Schweppes',
                                                                '1',
                                                                15.60,
                                                                '15.60 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000570',
                                                        nameCard: 'Schweppes')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000571',
                                                                'Coca Cola plus Coffee',
                                                                '1',
                                                                14.40,
                                                                '14.40 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000571',
                                                        nameCard: 'Coca Cola plus Coffee')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000572',
                                                                'BonAqua 500 ml',
                                                                '1',
                                                                12.30,
                                                                '12.30 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000572',
                                                        nameCard: 'BonAqua    500 ml')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000573',
                                                                'BonAqua 1000 ml',
                                                                '1',
                                                                14.30,
                                                                '14.30 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000573',
                                                        nameCard: 'BonAqua 1000 ml')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000581',
                                                                'BonAqua 1500 ml',
                                                                '1',
                                                                15.50,
                                                                '15.50 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000581',
                                                        nameCard: 'BonAqua 1500 ml')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                            listItem =
                                                            global.ListItemMenu(
                                                                '000000574',
                                                                'FuzeTea',
                                                                '1',
                                                                12.20,
                                                                '12.20 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000574',
                                                        nameCard: 'FuzeTea')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                        listItem =
                                                        global.ListItemMenu(
                                                            '000000575',
                                                            'Burn',
                                                            '1',
                                                            23.20,
                                                            '23.20 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000575',
                                                        nameCard: 'Burn')),
                                                GestureDetector(
                                                    onTap: () async {
                                                      if (isButtonSaleDisabled) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        global.ListItemMenu
                                                        listItem =
                                                        global.ListItemMenu(
                                                            '000000579',
                                                            'Monster Energy',
                                                            '1',
                                                            30.50,
                                                            '30.50 грн');
                                                        global.listItemMenu
                                                            .add(listItem);
                                                        global.orderSum =
                                                            global.orderSum +
                                                                listItem.price;
                                                      });
                                                    },
                                                    child: const CardMenuBottle(
                                                        codeCard: '000000579',
                                                        nameCard: 'Monster Energy')),
                                              ],
                                            ),
                                          ),
                                          // Вкладка История
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 5, 5, 15),
                                            child: Scrollbar(
                                              controller: _controllerTwo,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: global.listItemMenuHistory.length,
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  final global.ListItemMenuHistory listItemMenuHistory =
                                                  global.listItemMenuHistory[index];

                                                  // Строка товара в списке заказа
                                                  return CardMenuHistory(
                                                      name: listItemMenuHistory.name.toString(),
                                                      order: listItemMenuHistory.order.toString(),
                                                      sum: listItemMenuHistory.sum.toString(),
                                                      date: listItemMenuHistory.date.toString().substring(0,19));
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardMenuHistory extends StatelessWidget {
  final String name;
  final String order;
  final String sum;
  final String date;

  const CardMenuHistory(
      {Key? key,
        this.name = '',
        this.order = '',
        this.sum = '',
        this.date = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: const Color(0xFF1E2C32),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 10, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    fontSize: 18,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                order.trim(),
                //textAlign: TextAlign.left,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardMenu extends StatelessWidget {
    final String codeCard;
    final String nameCard;
    final String priceCard;
    final String sumCard;

    const CardMenu(
        {Key? key,
        this.codeCard = '',
        this.nameCard = '',
        this.priceCard = '',
        this.sumCard = ''})
        : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: const Color(0xFF1E2C32),
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
              child: Icon(
                FontAwesomeIcons.coffee,
                size: 20,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Text(sumCard,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    fontSize: 18,
                  )),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Text(
                nameCard,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

class CardMenuBottle extends StatelessWidget {
  final String codeCard;
  final String nameCard;

  const CardMenuBottle(
      {Key? key,
        this.codeCard = '',
        this.nameCard = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: const Color(0xFF1E2C32),
        elevation: 4,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Icon(
                FontAwesomeIcons.wineBottle,
                size: 20,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
              child: Text(
                nameCard,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      );
    }
}

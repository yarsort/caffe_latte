
library caffe_latte.global;

// Сумма заказа
double orderSum = 0.00;

// ФИО клиента
String nameClient = '';

// Штрихкод клиента
String barcodeClientAfterScanning = '';
String barcodeClient = '';

// Стандартная запись о необходимости сканирования
const textScanBarcode = 'Відскануйте ШтрихКіт';

// Текст на форме
String textInfo = 'Відскануйте ШтрихКіт';

// Список товаров вкладки меню "Кофе машина"
List<ListItemMenu> listItemMenu = [];

// Список товаров вкладки меню "Холодильник"
List<ListItemMenuFreeze> listItemMenuFreeze = [];

// Список заказов в истории
List<ListItemMenuHistory> listItemMenuHistory = [];

// Блюдо, которое заказывают в первой вкладке
class ListItemMenu {
  final String code;
  final String name;
  final String count;
  final double price;
  final String sum;

  ListItemMenu(this.code, this.name, this.count,  this.price, this.sum);

  Map toJson() {
    return {
      'code': code,
      'name': name,
      'count': count,
      'price': price,
      'sum': sum
    };
  }
}

// Исторический заказ клиента
class ListItemMenuHistory {
  final String name;
  final double sum;
  final String order;
  final DateTime date;

  ListItemMenuHistory(this.name, this.sum, this.order, this.date);

  Map toJson() {
    return {
      'name': nameClient,
      'sum': sum,
      'order': order,
      'date': date,
    };
  }
}

// Блюдо, которое заказывают во второй вкладке
class ListItemMenuFreeze {
  final String code;
  final String name;
  final String count;
  final double price;
  final String sum;

  ListItemMenuFreeze(this.code, this.name, this.count, this.sum, this.price);
}

import 'package:flutter/material.dart';
import 'package:agent_logger/agent_logger.dart';
import 'package:agent_logger/logger.dart';

var logger = LoggerWriter();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3:
            true, //You can substitute any trigger condition for the logger
      ),
      home: AgentLogger(
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
        enable: true, // You can make
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    logger.i(
        '[log] {"promoItemsTop":[{"banner":{"id":447289,"image":"https://472415.selcdn.ru/mobile_app/promotion/87/nosrklvhyllkc3euvi1m7nuwrjdnq5pdfnqyx45m_0.jpg","title":"новый","description":"","categoryId":195,"categoryName":"Базовые модели"}},{"banner":{"id":446598,"image":"https://472415.selcdn.ru/mobile_app/promotion/84/l9kbt8ktrdgxxvecmy97kkuqwjnxc2fued8l1ey3_0.png","title":"ТЕСТОВЫЙ","description":"тест","categoryId":153,"categoryName":"Дети 0+"}},{"banner":{"id":446073,"image":"https://472415.selcdn.ru/mobile_app/promotion/83/xn0bgtkan0vcgc81x8pngcic5lf4npqgnkmya413_0.jpg","title":"КОМБЕЗНО","description":"","categoryId":"","categoryName":""}},{"banner":{"id":9668,"image":"https://472415.selcdn.ru/mobile_app/promotion/17/48uoGIHY4r2jKRPhP9dgKqwmknbcINk5aaWPrri9_0.jpg","title":"колор блок","description":"","categoryId":156,"categoryName":"Мамам и папам"}},{"banner":{"id":9752,"image":"https://472415.selcdn.ru/mobile_app/promotion/14/jeLjuQvAnpQHf7E9NsS8tUN7HLdT1rpMIpxiNay9_0.jpg","title":"Комбез","description":"","categoryId":"","categoryName":""}},{"banner":{"id":9796,"image":"https://472415.selcdn.ru/mobile_app/promotion/43/zlQTMGF1lepCBeZDnEKBFQqCbRMfbNq2RctCujYN_0.jpg","title":"Пижамы","description":"ыфывфыв","categoryId":"","categoryName":""}},{"banner":{"id":9616,"image":"https://472415.selcdn.ru/mobile_app/promotion/8/nIfw9GLf8hUgCjahq5ZAXMqwdnegUkVICqYVWP1f_0.jpg","title":"яркие комбезы","description":"","categoryId":"","categoryName":""}}],"promoItemsBottom":[{"banner":{"id":442466,"image":"https://472415.selcdn.ru/mobile_app/promotion/41/ba3rhiileeumfvf4jqlo9kkbghtnbznmwemshktj_0.jpg","title":"Малыши зима","description":"","categoryId":174,"categoryName":"Верхняя одежда"}},{"banner":{"id":10007,"image":"https://472415.selcdn.ru/mobile_app/promotion/31/ls8pVw7XToMLkRORUgeSEdwmwhUL5JJFBuWkCize_0.jpg","title":"Подростки зимняя куртка","description":"","categoryId":"","categoryName":""}},{"banner":{"id":9927,"image":"https://472415.selcdn.ru/mobile_app/promotion/11/SNGItpJZvbXcYdovShv5vFmQy5gLUdwTSVJHJYzp_0.jpg","title":"Малыши флис","description":"","categoryId":"","categoryName":""}},{"banner":{"id":10046,"image":"https://472415.selcdn.ru/mobile_app/promotion/6/vMOzqQj3R8eLcHgpv9tAljuHVbvDGpgYTL0Fa0bT_0.jpg","title":"Подростки яркая база","description":"","categoryId":"","categoryName":""}}],"categories":[{"id":41,"title":"Верхняя одежда","image":"https://472415.selcdn.ru/mobile_app/home-category/41/T4a6VfTifewvKMTOE2RgaSUbxvXtiqhpWdIzx9hY_0.jpg","categories":[]},{"id":42,"title":"Комбинезоны","image":"https://472415.selcdn.ru/mobile_app/home-category/42/NxbbnGi9WOLMb9uKenLCOzzORcLKAB0mgAoZFDE5_0.jpg","categories":[]},{"id":43,"title":"Костюмы и толстовки","image":"https://472415.selcdn.ru/mobile_app/home-category/43/1abb4bbae55c2a389178.jpg","categories":[]},{"id":48,"title":"Футболки и лонгсливы","image":"https://472415.selcdn.ru/mobile_app/home-category/48/ptuy7uxpv3vallcvwxkpf3zm4og3j86gzovkekan_0.webp","categories":[]},{"id":45,"title":"Платья","image":"https://472415.selcdn.ru/mobile_app/home-category/45/xy5wFSegjmmAGgqxYOsvqFvWTOXXIhTz0SlH1kBi_0.jpg","categories":[]},{"id":39,"title":"Аксессуары","image":"https://472415.selcdn.ru/mobile_app/home-category/39/XJI860I16qpHZk1X5MpCI2MitzPhb46x0VuXEANy_0.jpg","categories":[]},{"id":47,"title":"Сертификаты","image":"https://472415.selcdn.ru/mobile_app/home-category/47/ATEEkjNSgVkCZWDwxg3cIIH96HUptsuxVlPCPfri_0.jpg","categories":[]},{"id":40,"title":"Брюки и шорты","image":"","categories":[]},{"id":54,"title":"Тест Главный экран","image":"https://472415.selcdn.ru/mobile_app/home-category/54/qs7ejbew7iyz29nrojj4nhrwbqak0dwkl1khv2dy_0.png","categories":[]}],"looks":[{"id":35,"image":"https://472415.selcdn.ru/mobile_app/look-book/35/ur7qeayqaznl3qoujyszkkhwranrctumln6utedx_1.jpg","title":"Family look","slides":[{"image":"https://472415.selcdn.ru/mobile_app/lookBookPage/78/p1ajbjtnchklcsw1ip3oiawdushsh6dounxzdln2_0.jpg","pageId":78,"isProducts":true,"products":[]},{"image":"https://472415.selcdn.ru/mobile_app/lookBookPage/105/0vczoajumzr4yncbxfiwqd2gbkqsvryycl8dwkmz_0.png","pageId":105,"isProducts":false,"products":[]},{"image":"https://472415.selcdn.ru/mobile_app/lookBookPage/103/54wz4nhxgar59t3ygudokkbnbh1wtlooey9umwnu_0.jpg","pageId":103,"isProducts":true,"products":[]}]},{"id":33,"image":"https://472415.selcdn.ru/mobile_app/look-book/33/ripalgkofwpxifk4iuogirhl35oipxoqhe67m4m5_1.jpg","title":"Зимние комбезы","slides":[{"image":"https://472415.selcdn.ru/mobile_app/lookBookPage/94/tmhfb4qrhlqyjyblggqz2cz16fy7tpdk8y5cpi9a_0.jpg","pageId":94,"isProducts":true,"products":[]},{"image":"https://472415.selcdn.ru/mobile_app/lookBookPage/97/er19pqumluqaxlumtg6viqzuudkrynrjjv7jd3ek_0.jpg","pageId":97,"isProducts":true,"products":[]}]}],"productSelection":[{"type":"viewed","title":"Вы смотрели","products":[{"id":6615,"sku":"1R0467","title":"Комбинезон демисезонный стеганый \"Ментол\" 0+","status":1,"imageFit":"cover","smallImage":"https://472415.selcdn.ru/mobile_app/product/6615/DSC_5678_10.jpg","largeImage":"https://472415.selcdn.ru/mobile_app/product/6615/DSC_5678_10.jpg","colors":{"id":6,"title":"Зеленый","hex_code":"#32CD32"},"marketing_color":[{"id":18,"title":"Пудра","flag":"picture","value":"https://472415.selcdn.ru/mobile_app/marketing_colors/1673168457_0.png"}],"favorite":false,"inCart":false,"sizes":[{"size":{"id":37,"title":"56"},"quantity":6},{"size":{"id":38,"title":"62"},"quantity":0},{"size":{"id":40,"title":"68"},"quantity":0},{"size":{"id":39,"title":"74"},"quantity":1},{"size":{"id":18,"title":"80"},"quantity":2},{"size":{"id":19,"title":"86"},"quantity":2}],"minPrice":{"value":"3399.00","currency":"RUB"},"minOldPrice":null,"prices":[{"sizeId":37,"price":{"value":"3399.00","currency":"RUB"},"basePrice":{"value":"3399.00","currency":"RUB"}},{"sizeId":38,"price":{"value":"3399.00","currency":"RUB"},"basePrice":{"value":"3399.00","currency":"RUB"}},{"sizeId":40,"price":{"value":"3399.00","currency":"RUB"},"basePrice":{"value":"3399.00","currency":"RUB"}},{"sizeId":39,"price":{"value":"3599.00","currency":"RUB"},"basePrice":{"value":"3599.00","currency":"RUB"}},{"sizeId":18,"price":{"value":"3599.00","currency":"RUB"},"basePrice":{"value":"3599.00","currency":"RUB"}},{"sizeId":19,"price":{"value":"3599.00","currency":"RUB"},"basePrice":{"value":"3599.00","currency":"RUB"}}],"badges":null,"view":"Верхняя одежда","type":"Демисезонная","category":"Верхняя одежда","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/collection/verhnyaya-odezhda-2/product/kombinezon-steganyy-mentol0-2"},{"id":7964,"sku":"1R2999","title":"Комбинезон с капюшоном и карманами \"Уголь\" утепленный","status":1,"imageFit":"cover","smallImage":"https://472415.selcdn.ru/mobile_app/product/7964/DSC_7789_10.jpg","largeImage":"https://472415.selcdn.ru/mobile_app/product/7964/DSC_7789_10.jpg","colors":{"id":15,"title":"Черный","hex_code":"#000000"},"marketing_color":[],"favorite":false,"inCart":false,"sizes":[{"size":{"id":18,"title":"80"},"quantity":56},{"size":{"id":19,"title":"86"},"quantity":47},{"size":{"id":20,"title":"92"},"quantity":57},{"size":{"id":21,"title":"98"},"quantity":208},{"size":{"id":22,"title":"104"},"quantity":148},{"size":{"id":23,"title":"110"},"quantity":151},{"size":{"id":24,"title":"116"},"quantity":115},{"size":{"id":25,"title":"122"},"quantity":139},{"size":{"id":31,"title":"128"},"quantity":0},{"size":{"id":32,"title":"134"},"quantity":0}],"minPrice":{"value":"2999.00","currency":"RUB"},"minOldPrice":null,"prices":[{"sizeId":18,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":19,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":20,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":21,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":22,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":23,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":24,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":25,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":31,"price":{"value":"3499.00","currency":"RUB"},"basePrice":{"value":"3499.00","currency":"RUB"}},{"sizeId":32,"price":{"value":"3499.00","currency":"RUB"},"basePrice":{"value":"3499.00","currency":"RUB"}}],"badges":null,"view":"Комбинезоны","type":null,"category":"Мамам и папам","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/product/kombinezon-s-kapyushonom-i-karmanami-ugol-uteplennyy-2"},{"id":21174,"sku":"1R3832","title":"Комбинезон с капюшоном и карманами \"Кокос\" утепленный","status":1,"imageFit":"cover","smallImage":"https://472415.selcdn.ru/mobile_app/product/21174/lmsatmom2hgqllt90gkplkn7znptky5ugpfvlsrr_10.png","largeImage":"https://472415.selcdn.ru/mobile_app/product/21174/lmsatmom2hgqllt90gkplkn7znptky5ugpfvlsrr_10.png","colors":{"id":1,"title":"Бежевый","hex_code":"#FFE4C4"},"marketing_color":[],"favorite":false,"inCart":false,"sizes":[{"size":{"id":18,"title":"80"},"quantity":77},{"size":{"id":19,"title":"86"},"quantity":175},{"size":{"id":20,"title":"92"},"quantity":258},{"size":{"id":21,"title":"98"},"quantity":238},{"size":{"id":22,"title":"104"},"quantity":193},{"size":{"id":23,"title":"110"},"quantity":171},{"size":{"id":24,"title":"116"},"quantity":102},{"size":{"id":25,"title":"122"},"quantity":6}],"minPrice":{"value":"2999.00","currency":"RUB"},"minOldPrice":null,"prices":[{"sizeId":18,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":19,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":20,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":21,"price":{"value":"2999.00","currency":"RUB"},"basePrice":{"value":"2999.00","currency":"RUB"}},{"sizeId":22,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":23,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":24,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}},{"sizeId":25,"price":{"value":"3199.00","currency":"RUB"},"basePrice":{"value":"3199.00","currency":"RUB"}}],"badges":null,"view":"Комбинезоны","type":null,"category":"Базовые модели","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/product/kombinezon-s-kapyushonom-i-karmanami-kokos-uteplennyy-2"},{"id":23585,"sku":"1R2879","title":"Сапожки на меху \"Шоколад\" 0+","status":1,"imageFit":"cover","smallImage":"https://472415.selcdn.ru/mobile_app/product/23585/DSC_5867_10.jpg","largeImage":"https://472415.selcdn.ru/mobile_app/product/23585/DSC_5867_10.jpg","colors":{"id":7,"title":"Коричневый","hex_code":"#8B4513"},"marketing_color":[],"favorite":false,"inCart":false,"sizes":[{"size":{"id":144,"title":"56-62"},"quantity":14},{"size":{"id":98,"title":"68-74"},"quantity":0}],"minPrice":{"value":"1019.00","currency":"RUB"},"minOldPrice":{"value":"1199.00","currency":"RUB"},"prices":[{"sizeId":144,"price":{"value":"1019.00","currency":"RUB"},"basePrice":{"value":"1199.00","currency":"RUB"}},{"sizeId":98,"price":{"value":"1019.00","currency":"RUB"},"basePrice":{"value":"1199.00","currency":"RUB"}}],"badges":[{"id":3,"title":"последний размер","image":"","color":"#C98DEE"},{"id":2,"title":"-15%","image":"","color":"#5D5435"}],"view":"Верхняя одежда","type":"Зимняя","category":"Аксессуары","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/product/sapozhki-na-mehu-shokolad-3-18-m"},{"id":28796,"sku":"1R3690","title":"Пижама из рифленой ткани \"Вереск\"","status":1,"imageFit":"cover","smallImage":"https://472415.selcdn.ru/mobile_app/product/28796/dsc_4520_result_ea9e6f3135_10.jpg","largeImage":"https://472415.selcdn.ru/mobile_app/product/28796/dsc_4520_result_ea9e6f3135_10.jpg","colors":{"id":14,"title":"Фиолетовый","hex_code":"#800080"},"marketing_color":[],"favorite":false,"inCart":false,"sizes":[{"size":{"id":18,"title":"80"},"quantity":1},{"size":{"id":19,"title":"86"},"quantity":29},{"size":{"id":20,"title":"92"},"quantity":61},{"size":{"id":21,"title":"98"},"quantity":66},{"size":{"id":22,"title":"104"},"quantity":71},{"size":{"id":23,"title":"110"},"quantity":71},{"size":{"id":24,"title":"116"},"quantity":51},{"size":{"id":25,"title":"122"},"quantity":26},{"size":{"id":31,"title":"128"},"quantity":3},{"size":{"id":32,"title":"134"},"quantity":2}],"minPrice":{"value":"1439.00","currency":"RUB"},"minOldPrice":{"value":"1599.00","currency":"RUB"},"prices":[{"sizeId":18,"price":{"value":"1439.00","currency":"RUB"},"basePrice":{"value":"1599.00","currency":"RUB"}},{"sizeId":19,"price":{"value":"1439.00","currency":"RUB"},"basePrice":{"value":"1599.00","currency":"RUB"}},{"sizeId":20,"price":{"value":"1439.00","currency":"RUB"},"basePrice":{"value":"1599.00","currency":"RUB"}},{"sizeId":21,"price":{"value":"1439.00","currency":"RUB"},"basePrice":{"value":"1599.00","currency":"RUB"}},{"sizeId":22,"price":{"value":"1619.00","currency":"RUB"},"basePrice":{"value":"1799.00","currency":"RUB"}},{"sizeId":23,"price":{"value":"1619.00","currency":"RUB"},"basePrice":{"value":"1799.00","currency":"RUB"}},{"sizeId":24,"price":{"value":"1619.00","currency":"RUB"},"basePrice":{"value":"1799.00","currency":"RUB"}},{"sizeId":25,"price":{"value":"1619.00","currency":"RUB"},"basePrice":{"value":"1799.00","currency":"RUB"}},{"sizeId":31,"price":{"value":"1799.00","currency":"RUB"},"basePrice":{"value":"1999.00","currency":"RUB"}},{"sizeId":32,"price":{"value":"1799.00","currency":"RUB"},"basePrice":{"value":"1999.00","currency":"RUB"}}],"badges":[{"id":2,"title":"-10%","image":"","color":"#5D5435"}],"view":"Пижамы","type":null,"category":"Ошибка поиска наименования категории","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/product/pizhama-iz-riflenoy-tkani-veresk-2"},{"id":38593,"sku":"Б1R4790","title":"Футболка оверсайз \"Bb team white\"","status":1,"imageFit":"cover","smallImage":"","largeImage":"","colors":{"id":2,"title":"Белый","hex_code":"#f3f3f3"},"marketing_color":[],"favorite":false,"inCart":false,"sizes":[{"size":{"id":18,"title":"80"},"quantity":11},{"size":{"id":19,"title":"86"},"quantity":10},{"size":{"id":20,"title":"92"},"quantity":0},{"size":{"id":21,"title":"98"},"quantity":22},{"size":{"id":22,"title":"104"},"quantity":19},{"size":{"id":23,"title":"110"},"quantity":8},{"size":{"id":24,"title":"116"},"quantity":5},{"size":{"id":25,"title":"122"},"quantity":4}],"minPrice":{"value":"899.00","currency":"RUB"},"minOldPrice":null,"prices":[{"sizeId":18,"price":{"value":"899.00","currency":"RUB"},"basePrice":{"value":"899.00","currency":"RUB"}},{"sizeId":19,"price":{"value":"899.00","currency":"RUB"},"basePrice":{"value":"899.00","currency":"RUB"}},{"sizeId":20,"price":{"value":"899.00","currency":"RUB"},"basePrice":{"value":"899.00","currency":"RUB"}},{"sizeId":21,"price":{"value":"899.00","currency":"RUB"},"basePrice":{"value":"899.00","currency":"RUB"}},{"sizeId":22,"price":{"value":"999.00","currency":"RUB"},"basePrice":{"value":"999.00","currency":"RUB"}},{"sizeId":23,"price":{"value":"999.00","currency":"RUB"},"basePrice":{"value":"999.00","currency":"RUB"}},{"sizeId":24,"price":{"value":"999.00","currency":"RUB"},"basePrice":{"value":"999.00","currency":"RUB"}},{"sizeId":25,"price":{"value":"999.00","currency":"RUB"},"basePrice":{"value":"999.00","currency":"RUB"}}],"badges":null,"view":"Майки и футболки","type":null,"category":"Футболки","isCertificate":false,"product_site_url":"https://bunglyboo-bsh916.myinsales.ru/product/futbolka-oversayz-bb-team-white-2"}]}]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

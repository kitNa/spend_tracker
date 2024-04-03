import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

//https://docs.flutter.dev/ui/animations
//https://api.flutter.dev/flutter/widgets/ImplicitlyAnimatedWidget-class.html
// https://api.flutter.dev/flutter/dart-core/Duration-class.html
// https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html
// https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html
// https://api.flutter.dev/flutter/widgets/AnimatedDefaultTextStyle-class.html
// https://api.flutter.dev/flutter/widgets/AnimatedWidget-class.html
// https://api.flutter.dev/flutter/widgets/SingleTickerProviderStateMixin-mixin.html
// https://api.flutter.dev/flutter/animation/AnimationController-class.html
// https://api.flutter.dev/flutter/animation/Animation-class.html
// https://api.flutter.dev/flutter/animation/Curves-class.html
// https://api.flutter.dev/flutter/animation/AnimationController-class.html https://api.flutter.dev/flutter/dart-ui/Offset-class.html
// https://api.flutter.dev/flutter/widgets/SlideTransition-class.html
// https://api.flutter.dev/flutter/animation/CurvedAnimation-class.html
// https://api.flutter.dev/flutter/animation/Interval-class.html

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween<double>(
      begin: 0,
      end: 400,
    ).animate(_controller)
      //дві крапки - це каскадна нотація в Dart. Це дозволяє нам робити послідовні
      //виклики методів на одному і тому ж об'єкті. Можна об'єднати стільки
      // викликів скільки потрібно.
      ..addStatusListener((AnimationStatus status) {
        //addStatusListener дозволяє нам додати зворотний виклик, який очікує на
        // зміни в анімації. Тут ми перевіряємо, чи анімація завершена, і якщо
        // так, то змінюємо її на протилежну.
        if (status == AnimationStatus.dismissed) {
          //reverse метод змінить анімацію до початкового значення, але
          // анімуватиме процес протягом вказаного _controller часу.
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          //Якщо статус закрито, ми переміщуємо анімацію вперед.
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (_, __) {
          //За допомогою віджета Трансформування ви можете обертати,
          // масштабувати або зміщувати дочірній віджет за допомогою
          // різних конструкторів.
          return Transform.rotate(
            //Тут ми змінюємо ракурс: нашого Зображення. Для нашої формули ми
            // використовуємо постійну числа пі з математичної бібліотеки, яку
            // ми імпортували. Це призведе до того, що наше зображення буде
            // обертатися в міру того, як тривалість буде змінюватися від 0 до
            // 5 секунд.
            angle: _controller.value * 2.0 * math.pi,
              child: Image.asset(
                  'lib/assets/images/image.jpg',
              width: _animation.value,
              height: _animation.value,),
          );
        },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';


void main(){
  return runApp(BoxAnimation());
}


class BoxAnimation extends StatefulWidget{
  const BoxAnimation({super.key});

  @override
  State<BoxAnimation> createState(){
    return BoxAnimationState();
  }
}

class BoxAnimationState extends State<BoxAnimation>{

  int index = 0;
  int pos = 0;
  Control control = Control.playFromStart;
  List<Color> roulette = [Colors.purple,
    Colors.orange,
    Colors.black,
    Colors.grey,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,];

  List<double> xdir = [1, 1, 0, -1, -1, -1, 0, 1];
  List<double> ydir = [0, 1, 1, 1, 0, -1, -1, -1];


  bool colorDir = false;
  bool movDir = false;

  int relativeCol = 2;
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Animación rotacional"),
            actions: [


              Row(
                children: [
                  Text(
                    colorDir ? 'Color - ON' : 'Color - OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  TernarySwitch(
                      key: const Key("Susi"),
                      onChanged: (index){
                        setState(() {
                          if(index == 0){
                            relativeCol = 1;
                          }
                          else if(index == 1){
                            relativeCol = 2;
                          }
                          else{
                            relativeCol = 3;
                          }
                          print(relativeCol);
                        });
                      })
                ],
              ),

              Row(
                children: [
                  Text(
                    movDir ? 'Mov - ON' : 'Mov - OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Switch(
                    value: movDir,
                    onChanged: (value) {
                      setState(() {
                        movDir = value;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
          body: GestureDetector(
            onTapDown: (details){
              setState(() {
                int p = movDir? 2 : -2;

                index = (index+p)%8;
                pos = (index+relativeCol)%8;

                control = Control.playFromStart;
              });
            },

            child: Stack(
              children: [

                Positioned.fill(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),


                // node(0, 0, (index+5)%8, -100, 100, 1, 1),
                // node(0, 0, (index+1)%8, 100, -100, 1, 1),
                // node(0, 0, (index+7)%8, -100, 100,  -1, 1),
                // node(0, 0, (index+3)%8, 100, -100, -1, 1),
                //
                // node(0, 0, (index+4)%8, -100, 100, 1, 0),
                // node(0, 0, (index+0)%8, 100, -100, 1, 0),
                // node(0, 0, (index+6)%8, -100, 100, 0, 1),
                // node(0, 0, (index+2)%8, 100, -100, 0, 1),

                node(0, 0, (index+0)%8, -100, 100),
                node(0, 0, (index+1)%8, -100, 100),
                node(0, 0, (index+2)%8, -100, 100),
                node(0, 0, (index+3)%8, -100, 100),

                node(0, 0, (index+4)%8, -100, 100),
                node(0, 0, (index+5)%8, -100, 100),
                node(0, 0, (index+6)%8, -100, 100),
                node(0, 0, (index+7)%8, -100, 100),

              ],
            ),
          )
      ),
    );
  }

  Widget node(double offx, double offy,
      int i,
      double begin, double end){


    return Align(
      alignment: Alignment(offx, offy),
      child: CustomAnimationBuilder(
        builder: (BuildContext context, value, Widget? child) {
          int f = end >= begin? 1 : -1;

          int p = movDir? 2 : -2;

          double fx = xdir[i], fy = ydir[i];
          Color colorState = roulette[(i-pos)%8];

          if(f*value >= f*(begin+end)/2){
            fy = ydir[(i+p+8)%8];
            fx = xdir[(i+p+8)%8];
            //colorState = roulette[(i-(pos+relativeCol) + 8)%8];
          }

          return Transform.translate(
            offset: Offset(fx*value.abs(), fy*value.abs()),
            child: Container(
              //child: Text("$i"),
              height: 70,
              width: 70,
              color: colorState,
            ),
          );
        },
        duration: const Duration(milliseconds: 2000),
        tween: Tween(begin: begin, end: end),
        control: control,
        curve: Curves.slowMiddle,
        //curve: Curves.linear,
      ),

    );

  }
}


class TernarySwitch extends StatefulWidget {
  final ValueChanged<int> onChanged;

  TernarySwitch({required Key key, required this.onChanged}) : super(key: key);

  @override
  _TernarySwitchState createState() => _TernarySwitchState();
}

class _TernarySwitchState extends State<TernarySwitch> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 35,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.deepPurple,

        borderRadius: BorderRadius.circular(50),
      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 0;
                widget.onChanged(_selectedIndex);
              });
            },
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _selectedIndex == 0 ? Colors.white: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25.0),
              ),

            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 1;
                widget.onChanged(_selectedIndex);
              });
            },
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _selectedIndex == 1 ? Colors.white: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 2;
                widget.onChanged(_selectedIndex);
              });
            },
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _selectedIndex == 2 ? Colors.white: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum HeightInputTypes { centimeters,meter, feetInches }

enum WeightInputTypes { kg, lb }

class BmiCalculatorPro extends StatefulWidget {
  const BmiCalculatorPro({super.key});

  @override
  State<BmiCalculatorPro> createState() => _BmiCalculatorProState();
}

class _BmiCalculatorProState extends State<BmiCalculatorPro> {
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _lbCtrl = TextEditingController();
  final TextEditingController _cmCtrl = TextEditingController();
  final TextEditingController _mCtrl = TextEditingController();
  final TextEditingController _feetCtrl = TextEditingController();
  final TextEditingController _inchCtrl = TextEditingController();

  HeightInputTypes _heightType = HeightInputTypes.centimeters;
  WeightInputTypes _weighthtType = WeightInputTypes.kg;
  String _bmiResult = "";
  String _bmiCategory = "";
  Color categoryColor  = Colors.grey;

  //Custom Snackbar
  void CustomSnk(String txt){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(txt),
        duration: const Duration(seconds: 2),
    ));
  }

  ///Conversion
  double lbToKg(double lb) => lb * 0.453;                                      // pounds -> kg
                         //cm -> meter



  @override
  void dispose() {
    _weightCtrl.dispose();
    _lbCtrl.dispose();
    _cmCtrl.dispose();
    _mCtrl.dispose();
    _feetCtrl.dispose();
    _inchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator Pro'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [

            //Weight
            Text(
              'Weight Input Type:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            SegmentedButton<WeightInputTypes>(
              segments: [
                ButtonSegment(
                  value: WeightInputTypes.kg,
                  label: const Text('"kg"'),
                ),
                ButtonSegment(
                  value: WeightInputTypes.lb,
                  label: const Text('"lb"'),
                ),

              ],
              selected: {_weighthtType},
              onSelectionChanged: (value) =>
                  setState(() => _weighthtType = value.first),
            ),
            SizedBox(height: 8.0),
            if(_weighthtType == WeightInputTypes.kg)...[
              Card(
                child: TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ]else...[
              Card(
                child: TextFormField(
                  controller: _lbCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (lb)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
//Height

            const SizedBox(height: 16.0),
            Text(
              'Height Input Type:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            SegmentedButton<HeightInputTypes>(
              segments: [
                ButtonSegment(
                  value: HeightInputTypes.centimeters,
                  label: const Text('"cm"'),
                ),
                ButtonSegment(
                  value: HeightInputTypes.meter,
                  label: const Text('"m"'),
                ),
                ButtonSegment(
                  value: HeightInputTypes.feetInches,
                  label: const Text('"ft/in"'),
                ),
              ],
              selected: {_heightType},
              onSelectionChanged: (value) =>
                  setState(() => _heightType = value.first),
            ),
            SizedBox(height: 8.0),
            if (_heightType == HeightInputTypes.centimeters) ...[
              Card(
                child: TextFormField(
                  controller: _cmCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'centimeters (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ]
              else if(_heightType == HeightInputTypes.meter)...[
              Card(
                child: TextFormField(
                  controller: _mCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Meter (m)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            ]
            else ...[
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: TextFormField(
                        controller: _feetCtrl,
                        decoration: const InputDecoration(
                          labelText: "Feet",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      child: TextFormField(
                        controller: _inchCtrl,
                        decoration: const InputDecoration(
                          labelText: "Inch",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calculate),
                  label: const Text("Calculate BMI"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reset"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Divider(),
            if(_bmiResult != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("Your BMI Score ",style: Theme.of(context).textTheme.titleMedium,),
                      SizedBox(height: 12,),
                      Text(
                        _bmiResult,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Chip(
                        label: Text(
                          _bmiCategory,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),

                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ],
                  ),
                )
              )


          ],
        ),
      ),
    );
  }
}

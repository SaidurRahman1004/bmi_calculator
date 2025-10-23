import 'package:flutter/material.dart';

enum HeightInputTypes { centimeters, meter, feetInches }

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
  Color categoryColor = Colors.grey;

  //Custom Snackbar
  void CustomSnk(String txt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(txt), duration: const Duration(seconds: 2)),
    );
  }

  ///Conversion
  ///
  //weight
  double _getWeight() {
    if (_weighthtType == WeightInputTypes.kg) {
      return double.parse(_weightCtrl.text.trim());
    } else {
      return double.parse(_lbCtrl.text.trim()) * 0.453592;   //lb to kg
    }
  }


  //cm to meter
  double? cmToMeter() {
    final cm = double.tryParse(_cmCtrl.text.trim());
    if (cm == null || cm <= 0) {
      CustomSnk("Enter valid height (cm)");
      return null;
    }

    return cm / 100;
  }

  ///fet inch to meter methode
  double? fetInchToMeter() {
    final feet = double.tryParse(_feetCtrl.text.trim()) ?? 0;
    final inch = double.tryParse(_inchCtrl.text.trim()) ?? 0;
    if ( feet <= 0 && inch <= 0) {
      CustomSnk("Enter valid height (ft/in)");
      return null;
    }
    final totalInch = (feet * 12) + inch;
    return totalInch * 0.0254;
  }

  //Normalize Inch
  void normalizeInch() {
    final feet = double.tryParse(_feetCtrl.text.trim()) ?? 0;
    final inch = double.tryParse(_inchCtrl.text.trim()) ?? 0;

    if (inch >= 12) {
      final extraFeet = inch ~/ 12;
      final remainingInch = inch % 12;
      _feetCtrl.text = (feet + extraFeet).toString();
      _inchCtrl.text = remainingInch.toStringAsFixed(1);
    }
  }


  ///BMI Calculate Button
  void _calculateBMI() {
    FocusScope.of(context).unfocus();

    //weight
    double? weight = _getWeight();

    if (weight == null || weight <= 0) {
      CustomSnk("Enter valid weight");
      return;
    }

    //height

    double? heightInMeter;
    if (_heightType == HeightInputTypes.centimeters) {
      heightInMeter = cmToMeter();
    } else if (_heightType == HeightInputTypes.meter) {
      heightInMeter = double.tryParse(_mCtrl.text.trim());
      if (heightInMeter == null || heightInMeter <= 0) {
        CustomSnk("Enter valid height (m)");
        return;
      }
    } else {
      normalizeInch();
      heightInMeter = fetInchToMeter();
    }

    if (heightInMeter == null) {
      CustomSnk("Enter valid height");
      return;
    }



    final bmi = weight / (heightInMeter * heightInMeter);

    //Catagory And Color
    String category;
    Color color;

    if (bmi < 18.5) {
      category = "Underweight";
      color = Colors.blue;
    } else if (bmi < 25) {
      category = "Normal";
      color = Colors.green;
    } else if (bmi < 30) {
      category = "Overweight";
      color = Colors.orange;
    } else {
      category = "Obese";
      color = Colors.red;
    }

    setState(() {
      _bmiResult = bmi.toStringAsFixed(2);
      _bmiCategory = category;
      categoryColor = color;
    });
  }

  //reset All
  void _resetAll(){
    _weightCtrl.clear();
    _lbCtrl.clear();
    _cmCtrl.clear();
    _mCtrl.clear();
    _feetCtrl.clear();
    _inchCtrl.clear();
    setState(() {
      _bmiResult = "";
      _bmiCategory = "";
      categoryColor = Colors.grey;
    });
  }

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
//Ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator Pro',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
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
                  label: const Text('kg'),
                ),
                ButtonSegment(
                  value: WeightInputTypes.lb,
                  label: const Text('lb'),
                ),
              ],
              selected: {_weighthtType},
              onSelectionChanged: (value) =>
                  setState(() => _weighthtType = value.first),
            ),
            SizedBox(height: 8.0),
            if (_weighthtType == WeightInputTypes.kg) ...[
              Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: TextFormField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ] else ...[
              Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: TextFormField(
                  controller: _lbCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  label: const Text('cm'),
                ),
                ButtonSegment(
                  value: HeightInputTypes.meter,
                  label: const Text('m'),
                ),
                ButtonSegment(
                  value: HeightInputTypes.feetInches,
                  label: const Text('ft/in'),
                ),
              ],
              selected: {_heightType},
              onSelectionChanged: (value) =>
                  setState(() => _heightType = value.first),
            ),
            SizedBox(height: 8.0),
            if (_heightType == HeightInputTypes.centimeters) ...[
              Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: TextFormField(
                  controller: _cmCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'centimeters (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ] else if (_heightType == HeightInputTypes.meter) ...[
              Card(
                margin: EdgeInsets.symmetric(vertical: 4),
                child: TextFormField(
                  controller: _mCtrl,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Meter (m)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: TextFormField(
                        controller: _feetCtrl,
                        decoration: const InputDecoration(
                          labelText: "Feet",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: TextFormField(
                        controller: _inchCtrl,
                        decoration: const InputDecoration(
                          labelText: "Inch",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onEditingComplete: normalizeInch,
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
                  onPressed: () {
                    _calculateBMI();
                  },
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
                  onPressed: () {
                    _resetAll();
                  },
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
            SizedBox(height: 5),
            Divider(),
            if (_bmiResult.isNotEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Your BMI Score ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 12),
                      Text(
                        _bmiResult,
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),

                      Chip(
                        backgroundColor: categoryColor,
                        label: Text(
                          _bmiCategory,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

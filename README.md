# Circular Charts

Animated Flower-shaped chart for Flutter.

## Getting Started

To use this package, add `circular_charts` as a dependency in your `pubspec.yaml` file.

## Example

<img width="309" alt="Screenshot 2023-06-24 at 8 44 32 AM" src="https://github.com/Rachit2030/circular_charts/assets/69667845/78db3cc9-a2c1-46f9-b241-3ec5e179e6d7">


## Usage

Basic usage of `circular_charts` requires the following parameters:

- `chartHeight` _(double)_
- `chartWidth` _(double)_
- `pieChartChildNames` _(List<String>)_
- `pieChartPercentages` _(List<double>)_
- `pieChartStartColors` _(List<Color>)_
- `pieChartEndColors` _(List<Color>)_
- `isShowingLegend` _(bool)_
- `isShowingCentreCircle` _(bool)_
- `animationTime` _(double)_
- `centreCircleBackgroundColor` _(Color?)_
- `centreCirclePercentageTextStyle` _(TextStyle?)_
- `centreCircleSubtitleTextStyle` _(TextStyle?)_
- `centreCircleTitle` _(String?)_
- `overAllPercentage` _(double)_

```dart
CircularChart(
  isShowingCentreCircle: true,
  animationTime: 800,
  chartHeight: 300,
  chartWidth: 400,
  pieChartChildNames: [
    "Maths",
    "History",
    "Science",
    "Chemistry",
    "Physics",
    "English"
  ],
  pieChartEndColors: [
    Color(0xfffc7e00),
    Color(0xfffc6076),
    Color(0xff007ced),
    Color(0xff4e9b01),
    Color(0xff009efd),
    Color(0xffff4b63),
  ],
  pieChartStartColors: [
    Color(0xffffd200),
    Color(0xffff9231),
    Color(0xff00beeb),
    Color(0xff92d108),
    Color(0xff00dbbe),
    Color(0xfff280ff),
  ],
  pieChartPercentages: [0, 20, 20, 0, 0, 0],
  isShowingLegend: true,
),
```
A full example (as seen in the screenshots) can be found in example/lib/main.dart

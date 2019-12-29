/*
 * Copyright (C) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// ignore_for_file: omit_local_variable_types

import 'barcode_exception.dart';
import 'barcode_maps.dart';
import 'barcode_operations.dart';
import 'ean.dart';

class BarcodeEan13 extends BarcodeEan {
  const BarcodeEan13();

  @override
  String get name => 'EAN 13';

  @override
  Iterable<bool> convert(String data) sync* {
    data = checkLength(data, 13);

    // Start
    yield* add(BarcodeMaps.eanStartEnd, 3);

    int index = 0;
    final int first = BarcodeMaps.eanFirst[data.codeUnits.first];
    if (first == null) {
      throw BarcodeException(
          'Unable to encode "${String.fromCharCode(data.codeUnits.first)}" to $name Barcode');
    }

    for (int code in data.codeUnits.sublist(1)) {
      final List<int> codes = BarcodeMaps.ean[code];

      if (codes == null) {
        throw BarcodeException(
            'Unable to encode "${String.fromCharCode(code)}" to $name Barcode');
      }

      if (index == 6) {
        yield* add(BarcodeMaps.eanCenter, 5);
      }

      if (index < 6) {
        yield* add(codes[(first >> index) & 1], 7);
      } else {
        yield* add(codes[2], 7);
      }

      index++;
    }

    // Stop
    yield* add(BarcodeMaps.eanStartEnd, 3);
  }

  @override
  Iterable<BarcodeText> makeText(
    String data,
    double width,
    double height,
    double fontHeight,
  ) {
    data = checkLength(data, 13);
    return super.makeText(data, width, height, fontHeight);
  }
}
import 'dart:math' as math;

import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:yesterday/models/models.dart';
import 'package:yesterday/tile/tile.dart';

import '../test.dart';

void main() => group('ThumbnailGroup', () {
      testWidgets('displays labelText', (t) async {
        await t.pumpWidget(shell<String>(
          child: ThumbnailGroup(
            labelText: 'foo',
            tileContents: <TileContent>[].toBuiltList(),
          ),
        ));

        expect(find.text('foo'), findsOneWidget);
      });
      testWidgets('displays scrollable gallery of thumbnail tiles', (t) async {
        mockNetworkImagesFor(() async {
          final playlists = Iterable.generate(
                  10, (i) => Playlist((b) => b.name = 'Playlist $i'))
              .followedBy([Playlist((b) => b.name = 'foo')]);
          await t.pumpWidget(shell<String>(
            child: ThumbnailGroup(tileContents: playlists.toBuiltList()),
          ));

          expect(
            find.descendant(
              of: find.byType(ThumbnailTile),
              matching: find.text('Playlist 1'),
            ),
            findsOneWidget,
          );
          expect(
            find.descendant(
              of: find.byType(ThumbnailTile),
              matching: find.text('foo'),
            ),
            findsNothing,
          );
          await t.drag(
              find.text('Playlist 3'), Offset.fromDirection(math.pi, 500));
          await t.pumpAndSettle();
          expect(
            find.descendant(
              of: find.byType(ThumbnailTile),
              matching: find.text('Playlist 1'),
            ),
            findsNothing,
          );
          expect(
            find.descendant(
              of: find.byType(ThumbnailTile),
              matching: find.text('foo'),
            ),
            findsOneWidget,
          );
        });
      });
    });

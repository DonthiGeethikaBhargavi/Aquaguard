import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:aquaguard/features/pond/domain/models/pond_with_reading.dart';

import 'package:aquaguard/features/pond/domain/entities/pond_exception.dart';

import 'package:aquaguard/features/pond/data/datasources/pond_remote_datasource.dart';

import 'pond_provider.dart';

////////////////////////////////////////////////////////////
/// ADD STATE
////////////////////////////////////////////////////////////

class AddPondState {
  final bool isLoading;

  final String? error;

  const AddPondState({this.isLoading = false, this.error});

  AddPondState copyWith({bool? isLoading, String? error}) {
    return AddPondState(isLoading: isLoading ?? this.isLoading, error: error);
  }
}

////////////////////////////////////////////////////////////
/// ADD NOTIFIER
////////////////////////////////////////////////////////////

class AddPondStateNotifier extends StateNotifier<AddPondState> {
  final Ref _ref;

  final PondRemoteDataSource _dataSource = PondRemoteDataSource();

  AddPondStateNotifier(this._ref) : super(const AddPondState());

  ////////////////////////////////////////////////////////////
  /// ADD
  ////////////////////////////////////////////////////////////

  Future<bool> addPond({
    required String name,

    required double? latitude,

    required double? longitude,
  }) async {
    //////////////////////////////////////////////////////////
    /// VALIDATION
    //////////////////////////////////////////////////////////

    if (name.trim().isEmpty) {
      state = state.copyWith(error: 'Please enter a pond name.');

      return false;
    }

    if (name.trim().length < 2) {
      state = state.copyWith(error: 'Pond name is too short.');

      return false;
    }

    //////////////////////////////////////////////////////////
    /// LOADING
    //////////////////////////////////////////////////////////

    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw AddPondGenericException(details: 'User not authenticated');
      }

      ////////////////////////////////////////////////////////
      /// INSERT INTO REAL TABLE
      ////////////////////////////////////////////////////////

      await _dataSource.addPond(
        name: name.trim(),

        userId: user.id,

        lat: latitude ?? 0,

        lng: longitude ?? 0,
      );

      ////////////////////////////////////////////////////////
      /// SILENT BACKGROUND REFRESH
      ////////////////////////////////////////////////////////

      unawaited(_ref.read(pondProvider.notifier).refreshInBackground());

      ////////////////////////////////////////////////////////
      /// RESET
      ////////////////////////////////////////////////////////

      state = const AddPondState();

      return true;
    } on PondException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);

      return false;
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Couldn\'t add pond.');

      return false;
    }
  }

  ////////////////////////////////////////////////////////////
  /// CLEAR
  ////////////////////////////////////////////////////////////

  void clearError() {
    state = state.copyWith(error: null);
  }

  ////////////////////////////////////////////////////////////
  /// RESET
  ////////////////////////////////////////////////////////////

  void reset() {
    state = const AddPondState();
  }
}

////////////////////////////////////////////////////////////
/// DELETE STATE
////////////////////////////////////////////////////////////

class DeletePondState {
  final bool isLoading;

  final String? error;

  final PondWithReading? undoItem;

  final String? undoId;

  const DeletePondState({
    this.isLoading = false,

    this.error,

    this.undoItem,

    this.undoId,
  });

  DeletePondState copyWith({
    bool? isLoading,

    String? error,

    PondWithReading? undoItem,

    String? undoId,
  }) {
    return DeletePondState(
      isLoading: isLoading ?? this.isLoading,

      error: error,

      undoItem: undoItem,

      undoId: undoId,
    );
  }
}

////////////////////////////////////////////////////////////
/// DELETE NOTIFIER
////////////////////////////////////////////////////////////

class DeletePondStateNotifier extends StateNotifier<DeletePondState> {
  final Ref _ref;

  final PondRemoteDataSource _dataSource = PondRemoteDataSource();

  Timer? _deleteTimer;

  DeletePondStateNotifier(this._ref) : super(const DeletePondState());

  ////////////////////////////////////////////////////////////
  /// REQUEST DELETE
  ////////////////////////////////////////////////////////////

  Future<void> requestDelete(PondWithReading pond) async {
    //////////////////////////////////////////////////////////
    /// IMMEDIATE UI REMOVE
    //////////////////////////////////////////////////////////

    _ref.read(pondProvider.notifier).optimisticRemove(pond.pondId);

    //////////////////////////////////////////////////////////
    /// STATE
    //////////////////////////////////////////////////////////

    state = state.copyWith(undoItem: pond, undoId: pond.pondId, error: null);

    //////////////////////////////////////////////////////////
    /// TIMER
    //////////////////////////////////////////////////////////

    _deleteTimer?.cancel();

    _deleteTimer = Timer(const Duration(seconds: 3), () async {
      if (state.undoId == pond.pondId) {
        await _confirmDelete(pond.pondId);
      }
    });
  }

  ////////////////////////////////////////////////////////////
  /// UNDO
  ////////////////////////////////////////////////////////////

  void undoDelete() {
    final item = state.undoItem;

    if (item == null) return;

    //////////////////////////////////////////////////////////
    /// CANCEL TIMER
    //////////////////////////////////////////////////////////

    _deleteTimer?.cancel();

    //////////////////////////////////////////////////////////
    /// RESTORE UI
    //////////////////////////////////////////////////////////

    _ref.read(pondProvider.notifier).optimisticAdd(item);

    //////////////////////////////////////////////////////////
    /// RESET
    //////////////////////////////////////////////////////////

    state = const DeletePondState();
  }

  ////////////////////////////////////////////////////////////
  /// CONFIRM DELETE
  ////////////////////////////////////////////////////////////

  Future<void> _confirmDelete(String pondId) async {
    try {
      ////////////////////////////////////////////////////////
      /// DELETE FROM REAL TABLE
      ////////////////////////////////////////////////////////

      await _dataSource.deletePond(pondId);

      ////////////////////////////////////////////////////////
      /// SILENT REFRESH
      ////////////////////////////////////////////////////////

      unawaited(_ref.read(pondProvider.notifier).refreshInBackground());

      ////////////////////////////////////////////////////////
      /// RESET
      ////////////////////////////////////////////////////////

      state = const DeletePondState();
    } on PondException catch (e) {
      state = state.copyWith(error: e.message);
    } catch (_) {
      state = state.copyWith(error: 'Delete failed.');
    }
  }

  ////////////////////////////////////////////////////////////
  /// MANUAL CONFIRM
  ////////////////////////////////////////////////////////////

  Future<void> confirmDelete() async {
    if (state.undoId != null) {
      await _confirmDelete(state.undoId!);
    }
  }

  ////////////////////////////////////////////////////////////
  /// CLEAR UNDO
  ////////////////////////////////////////////////////////////

  void clearUndo() {
    _deleteTimer?.cancel();

    state = const DeletePondState();
  }

  ////////////////////////////////////////////////////////////
  /// CLEAR
  ////////////////////////////////////////////////////////////

  void clearError() {
    state = state.copyWith(error: null);
  }

  ////////////////////////////////////////////////////////////
  /// RESET
  ////////////////////////////////////////////////////////////

  void reset() {
    _deleteTimer?.cancel();

    state = const DeletePondState();
  }
}

////////////////////////////////////////////////////////////
/// PROVIDERS
////////////////////////////////////////////////////////////

final addPondStateProvider =
    StateNotifierProvider<AddPondStateNotifier, AddPondState>((ref) {
      return AddPondStateNotifier(ref);
    });

final deletePondStateProvider =
    StateNotifierProvider<DeletePondStateNotifier, DeletePondState>((ref) {
      return DeletePondStateNotifier(ref);
    });


import 'package:flutter/material.dart';

class UCloudHelperFunctions {

  static Widget? checkSingleRecordState<T>({required AsyncSnapshot<List<T>> snapshot, Widget? loader, Widget? error, Widget? nothingFound}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loader ?? const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {

      return error ?? Center(child: Text('Lỗi: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      return nothingFound ?? const Center(child: Text('Không có dữ liệu (No Data Found)'));
    }



    return null;
  }

  static Widget? checkMultiRecordState<T>({required AsyncSnapshot<List<T>> snapshot, Widget? loader, Widget? error, Widget? nothingFound}) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      if (loader != null) return loader;
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
      if (nothingFound != null) return nothingFound;
      return const Center(child: Text('No Data Found!'));
    }

    if (snapshot.hasError) {
      if (error != null) return error;
      return const Center(child: Text('Something went wrong.'));
    }

    return null;
  }
}
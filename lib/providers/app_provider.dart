import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AppProvider extends ChangeNotifier {
  String _userName = '';
  String _selectedUserName = '';
  
  List<User> _users = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  String _errorMessage = '';
  

  final int _perPage = 10;
  

  String get userName => _userName;
  String get selectedUserName => _selectedUserName;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _currentPage <= _totalPages;
  String get errorMessage => _errorMessage;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get perPage => _perPage;


  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setSelectedUserName(String name) {
    _selectedUserName = name;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUserName = '';
    notifyListeners();
  }

 
  Future<void> loadUsers({bool refresh = false}) async {
    print('loadUsers called - refresh: $refresh');
    print('Current state - users: ${_users.length}, isLoading: $_isLoading');
    
    if (refresh) {
      _currentPage = 1;
      _users.clear();
      _errorMessage = '';
      print('Refreshing - reset to page 1, cleared users');
    }

    _isLoading = refresh || _users.isEmpty;
    print('Setting isLoading to: $_isLoading');
    notifyListeners();

    try {
      print('Calling ApiService.getUsers($_currentPage, $_perPage)');
      
      final response = await ApiService.getUsers(_currentPage, _perPage);
      
      print('API Response received');
      print('Response data: ${response.data.length} users');
      print('Response page: ${response.page}');
      print('Response totalPages: ${response.totalPages}');
      
      if (refresh) {
        _users = response.data;
        print('Users replaced with new data');
      } else {
        _users.addAll(response.data);
        print('Users added to existing data');
      }
      
      _totalPages = response.totalPages;
      _currentPage = response.page + 1; 
      _errorMessage = '';
      
      print('Final state - users: ${_users.length}, currentPage: $_currentPage, totalPages: $_totalPages');
      
    } catch (e) {
      print('Error in loadUsers: $e');
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('Error message set to: $_errorMessage');
    }

    _isLoading = false;
    print('Setting isLoading to false');
    notifyListeners();
    print('loadUsers completed');
  }

 
  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !hasMoreData) {
      print('Skipping loadMoreUsers - isLoading: $_isLoadingMore, hasMoreData: $hasMoreData');
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      print('Loading more users - Page: $_currentPage');
      
      final response = await ApiService.getUsers(_currentPage, _perPage);
      
      _users.addAll(response.data);
      _totalPages = response.totalPages;
      _currentPage = response.page + 1; 
      _errorMessage = '';
      
      print('More users loaded: ${response.data.length}. Total: ${_users.length}');
      print('Updated currentPage to: $_currentPage, totalPages: $_totalPages');
      
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('Error in loadMoreUsers: $_errorMessage');
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  
  void resetPagination() {
    _currentPage = 1;
    _users.clear();
    _errorMessage = '';
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }


  Map<String, dynamic> getPaginationInfo() {
    return {
      'currentPage': _currentPage - 1, 
      'totalPages': _totalPages,
      'perPage': _perPage,
      'totalUsers': _users.length,
      'hasMoreData': hasMoreData,
    };
  }


  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }


  bool isPalindrome(String text) {
    if (text.isEmpty) return false;
    
 
    String cleanText = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    return cleanText == cleanText.split('').reversed.join('');
  }
}
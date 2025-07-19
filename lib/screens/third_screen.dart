import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _selectedUserName;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadUsers(refresh: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      if (provider.hasMoreData && !provider.isLoadingMore) {
        print('Triggering load more from scroll');
        provider.loadMoreUsers();
      }
    }
  }

  Future<void> _onRefresh() async {
    await Provider.of<AppProvider>(
      context,
      listen: false,
    ).loadUsers(refresh: true);
  }

  void _onUserTap(String userName) {
    setState(() {
      _selectedUserName = userName;
    });
    
    // 
    Future.delayed(const Duration(milliseconds: 500), () {
      Provider.of<AppProvider>(
        context,
        listen: false,
      ).setSelectedUserName(userName);
      Navigator.pop(context);
    });
  }

  Widget _buildLoadingIndicator({String? text}) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B637B)),
            ),
            if (text != null) ...[
              const SizedBox(height: 12),
              Text(
                text,
                style: const TextStyle(fontSize: 14, color: Color(0xFF8B8B8B)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Third Screen',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF04021D),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF554AF0),
            size: 33,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE5E5E5), height: 1.0),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {

          if (provider.isLoading && provider.users.isEmpty) {
            return _buildLoadingIndicator(text: 'Loading users...');
          }


          if (provider.errorMessage.isNotEmpty && provider.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading users',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      _loadUsers();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B637B),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: const Color(0xFF2B637B),
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount:
                  provider.users.length + (provider.isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) {
                if (index >= provider.users.length) {
                  return const SizedBox.shrink();
                }
                return const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE5E5E5),
                  indent: 80,
                  endIndent: 0,
                );
              },
              itemBuilder: (context, index) {

                if (index == provider.users.length && provider.isLoadingMore) {
                  return _buildLoadingIndicator(text: 'Loading more users...');
                }

                final user = provider.users[index];
                final isSelected = _selectedUserName == user.fullName;
                
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onUserTap(user.fullName),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 80,
                      color: isSelected 
                        ? const Color(0xFF2B637B).withOpacity(0.1)
                        : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: user.avatar != null
                                ? ClipOval(
                                    child: Image.network(
                                      user.avatar!,
                                      fit: BoxFit.cover,
                                      width: 56,
                                      height: 56,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                    Color
                                                  >(Color(0xFF2B637B)),
                                            ),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              size: 28,
                                              color: Colors.grey[600],
                                            );
                                          },
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Colors.grey[600],
                                  ),
                          ),
                          const SizedBox(width: 16),


                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected 
                                      ? const Color(0xFF2B637B)
                                      : const Color(0xFF04021D),
                                  ),
                                  child: Text(
                                    user.fullName,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 200),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected 
                                      ? const Color(0xFF2B637B)
                                      : const Color(0xFF8B8B8B),
                                  ),
                                  child: Text(
                                    user.email,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.chevron_right,
                            color: isSelected 
                              ? const Color(0xFF2B637B)
                              : Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
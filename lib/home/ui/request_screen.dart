import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sohyah/app/view/common/app_bar.dart';
import 'package:sohyah/home/bloc/home_state.dart';
import 'package:sohyah/home/ui/widgets/bottom_nav_widget.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  bool _showSentRequests = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(
        ctx: context,
        leadingCallBack: null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Toggle buttons
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSentRequests = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _showSentRequests
                            ? const Color(0xFFFF6868)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Requests Sent',
                        style: TextStyle(
                          color: _showSentRequests ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSentRequests = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !_showSentRequests
                            ? const Color(0xFFFF6868)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Requests Received',
                        style: TextStyle(
                          color: !_showSentRequests ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Requests count and filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '6 Requests Sent in Total',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.filter_list, color: Colors.red.shade300, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'All Requests',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Requests list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildRequestItem('Not accepted yet', Colors.purple),
                _buildRequestItem('Accepted', Colors.green),
                _buildRequestItem('Not accepted yet', Colors.purple),
                _buildRequestItem('Accepted', Colors.green),
                _buildRequestItem('Declined', Colors.red),
                _buildRequestItem('Not accepted yet', Colors.purple),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavWidget(), // Moved to Scaffold's bottomNavigationBar
    );
  }

  Widget _buildRequestItem(String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Note: 'bottom' should replace 'custom'
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meetup for Coffee',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'From Le Restaurant',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
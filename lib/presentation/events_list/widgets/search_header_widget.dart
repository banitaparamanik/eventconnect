import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchHeaderWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onFilterTap;
  final VoidCallback onSortTap;
  final int activeFilterCount;

  const SearchHeaderWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onFilterTap,
    required this.onSortTap,
    required this.activeFilterCount,
  });

  @override
  State<SearchHeaderWidget> createState() => _SearchHeaderWidgetState();
}

class _SearchHeaderWidgetState extends State<SearchHeaderWidget> {
  bool _isSearchFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.sp),
                    border: Border.all(
                      color: _isSearchFocused
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: _isSearchFocused ? 2 : 1,
                    ),
                  ),
                  child: TextField(
                    controller: widget.searchController,
                    focusNode: _searchFocusNode,
                    onChanged: widget.onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12.sp),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20.sp,
                        ),
                      ),
                      suffixIcon: widget.searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                widget.searchController.clear();
                                widget.onSearchChanged('');
                              },
                              icon: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20.sp,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                // Voice search functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Voice search not implemented')),
                                );
                              },
                              icon: CustomIconWidget(
                                iconName: 'mic',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20.sp,
                              ),
                            ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.sp,
                        vertical: 12.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.sp),
              _buildFilterButton(),
              SizedBox(width: 8.sp),
              _buildSortButton(),
            ],
          ),
          if (widget.activeFilterCount > 0) ...[
            SizedBox(height: 12.sp),
            _buildActiveFiltersIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      decoration: BoxDecoration(
        color: widget.activeFilterCount > 0
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(
          color: widget.activeFilterCount > 0
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: widget.onFilterTap,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: widget.activeFilterCount > 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.sp,
            ),
          ),
          if (widget.activeFilterCount > 0)
            Positioned(
              right: 6.sp,
              top: 6.sp,
              child: Container(
                padding: EdgeInsets.all(2.sp),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 16.sp,
                  minHeight: 16.sp,
                ),
                child: Text(
                  widget.activeFilterCount.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: IconButton(
        onPressed: widget.onSortTap,
        icon: CustomIconWidget(
          iconName: 'sort',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildActiveFiltersIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'filter_alt',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16.sp,
          ),
          SizedBox(width: 4.sp),
          Text(
            '${widget.activeFilterCount} filter${widget.activeFilterCount > 1 ? 's' : ''} active',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(width: 4.sp),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

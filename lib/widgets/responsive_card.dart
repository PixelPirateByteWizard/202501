import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_utils.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding = padding?.responsive(context) ?? 
        const EdgeInsets.all(16).responsive(context);
    final responsiveMargin = margin?.responsive(context) ?? 
        const EdgeInsets.all(8).responsive(context);

    return Container(
      margin: responsiveMargin,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.cardColor.withValues(alpha: 0.6),
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border ?? Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: AppTheme.accentColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: responsivePadding,
        child: child,
      ),
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? baseFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.baseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveStyle = style?.copyWith(
      fontSize: baseFontSize != null 
          ? ResponsiveUtils.getResponsiveFontSize(context, baseFontSize!)
          : style?.fontSize != null
              ? ResponsiveUtils.getResponsiveFontSize(context, style!.fontSize!)
              : null,
    ) ?? TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
    );

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const ResponsiveIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size != null 
          ? ResponsiveUtils.getIconSize(context, size!)
          : ResponsiveUtils.getIconSize(context, 24),
      color: color,
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final double? height;
  final double? minWidth;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.style,
    this.height,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = height != null 
        ? ResponsiveUtils.getButtonHeight(context, defaultHeight: height!)
        : ResponsiveUtils.getButtonHeight(context);

    return SizedBox(
      height: responsiveHeight,
      width: minWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final int defaultColumns;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveGridView({
    super.key,
    required this.children,
    this.defaultColumns = 2,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: ResponsiveUtils.getGridColumns(context, defaultColumns: defaultColumns),
      crossAxisSpacing: crossAxisSpacing != null 
          ? ResponsiveUtils.getResponsiveSpacing(context, crossAxisSpacing!)
          : ResponsiveUtils.getResponsiveSpacing(context, 16),
      mainAxisSpacing: mainAxisSpacing != null 
          ? ResponsiveUtils.getResponsiveSpacing(context, mainAxisSpacing!)
          : ResponsiveUtils.getResponsiveSpacing(context, 16),
      childAspectRatio: childAspectRatio != null 
          ? ResponsiveUtils.getCardAspectRatio(context, defaultRatio: childAspectRatio!)
          : ResponsiveUtils.getCardAspectRatio(context),
      padding: padding?.responsive(context),
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
    this.child,
  });

  const ResponsiveSizedBox.width(double width, {super.key, this.child}) 
      : width = width, height = null;

  const ResponsiveSizedBox.height(double height, {super.key, this.child}) 
      : height = height, width = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? ResponsiveUtils.getResponsiveSpacing(context, width!) : null,
      height: height != null ? ResponsiveUtils.getResponsiveSpacing(context, height!) : null,
      child: child,
    );
  }
}
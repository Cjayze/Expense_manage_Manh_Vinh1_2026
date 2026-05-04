import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
	const CommonHeader({
		super.key,
		required this.title,
	});

	final String title;

	@override
	Widget build(BuildContext context) {
		final canPop = Navigator.of(context).canPop();

		return SafeArea(
			bottom: false,
			child: Padding(
				padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
				child: Row(
					children: [
						IconButton(
							onPressed: canPop ? () => Navigator.of(context).maybePop() : null,
							icon: const Icon(Icons.arrow_back_ios_new),
							tooltip: 'Back',
						),
						Expanded(
							child: Text(
								title,
								textAlign: TextAlign.center,
								style: Theme.of(context).textTheme.titleLarge,
							),
						),
						IconButton(
							onPressed: () {},
							icon: const Icon(Icons.search),
							tooltip: 'Search',
						),
						const SizedBox(width: 6),
						const CircleAvatar(
							radius: 16,
							child: Text('V'),
						),
					],
				),
			),
		);
	}
}

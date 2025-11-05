import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ROOT WIDGET - StatelessWidget (Never changes)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // StatelessWidget builds once and never changes
  // Perfect for static content like app configuration
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful vs Stateless Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WidgetComparisonScreen(),
    );
  }
}

// MAIN SCREEN - Shows both widget types side by side
class WidgetComparisonScreen extends StatefulWidget {
  const WidgetComparisonScreen({super.key});

  @override
  State<WidgetComparisonScreen> createState() => _WidgetComparisonScreenState();
}

class _WidgetComparisonScreenState extends State<WidgetComparisonScreen> {
  // Counter to force rebuild of StatelessWidget
  int _parentCounter = 0;

  // Method to increment counter and rebuild StatelessWidget
  void _forceStatelessRebuild() {
    setState(() {
      _parentCounter++;
      print('Parent setState() called - forcing StatelessWidget rebuild');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful vs Stateless Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Control button to demonstrate StatelessWidget rebuild
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.touch_app, color: Colors.purple, size: 18),
                const SizedBox(width: 6),
                const Flexible(
                  child: Text(
                    'Force StatelessWidget Rebuild:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: _forceStatelessRebuild,
                  icon: const Icon(Icons.refresh, size: 14),
                  label: Text('Rebuild ($_parentCounter)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    foregroundColor: Colors.purple.shade700,
                    elevation: 2,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Row(
              children: [
                // LEFT HALF - Stateless Widget Example (passing external data)
                Expanded(
                  child: StatelessWidgetExample(
                    externalCounter: _parentCounter,
                  ),
                ),
                // DIVIDER - Visual separation between the two halves
                const VerticalDivider(
                  width: 2,
                  thickness: 2,
                  color: Colors.grey,
                ),
                // RIGHT HALF - Stateful Widget Example
                const Expanded(child: StatefulWidgetExample()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================
// STATELESS WIDGET EXAMPLE (LEFT HALF)
// ===============================================

/// STATELESS WIDGET - Content never changes after creation
///
/// Key characteristics:
/// - Immutable (cannot change)
/// - No setState() method
/// - Build method called only once (or when parent rebuilds)
/// - Perfect for static content like text, icons, images
/// - Lightweight and efficient

// Static variable to track build calls (for demonstration only)
int _statelessBuildCount = 0;

// Static variable to demonstrate that StatelessWidget can't update itself
int _statelessInternalCounter = 0;

class StatelessWidgetExample extends StatelessWidget {
  // Add a parameter to receive data from parent
  final int externalCounter;

  const StatelessWidgetExample({super.key, this.externalCounter = 0});

  @override
  Widget build(BuildContext context) {
    // Increment build count each time build() is called
    _statelessBuildCount++;

    // Get current time to show when build() was called
    final buildTime = DateTime.now();
    final timeString =
        '${buildTime.hour}:${buildTime.minute.toString().padLeft(2, '0')}:${buildTime.second.toString().padLeft(2, '0')}';

    // This demonstrates that even StatelessWidget can be rebuilt
    // when its parent widget rebuilds (like during hot reload)
    print(
      'StatelessWidget build() called #$_statelessBuildCount at $timeString',
    );

    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header Section with Build Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'STATELESS WIDGET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Build count indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Build Count: $_statelessBuildCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // External Counter Display - Shows data from parent
            Card(
              elevation: 4,
              color: Colors.cyan.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.input,
                          color: Colors.cyan.shade600,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'Data from Parent:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$externalCounter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updates when parent rebuilds!',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.cyan.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Internal Counter - Demonstrates StatelessWidget limitation
            Card(
              elevation: 4,
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.block, color: Colors.red.shade600, size: 14),
                        const SizedBox(width: 4),
                        const Flexible(
                          child: Text(
                            'Internal Counter:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_statelessInternalCounter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: () {
                        // This increments the counter but won't show until rebuild
                        _statelessInternalCounter++;
                        print(
                          'StatelessWidget internal counter incremented to $_statelessInternalCounter (not visible until rebuild)',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade700,
                        textStyle: const TextStyle(fontSize: 11),
                      ),
                      child: const Text('Increment (Hidden)'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click "Force Rebuild" to see changes!',
                      style: TextStyle(
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        color: Colors.red.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Build Time Display
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                children: [
                  const Text(
                    '🕐 Last Built At:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    timeString,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Static Content Examples with Visual Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.lock, size: 40, color: Colors.blue),
                // Pulsing circle to show "static" nature
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Static Widget Structure',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Information Card with Visual Cues
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Build() Method Behavior:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _buildInfoRow('Called when widget is first created'),
                    _buildInfoRow('Called when parent widget rebuilds'),
                    _buildInfoRow('Called during hot reload'),
                    _buildInfoRow('Widget structure remains immutable'),
                    _buildInfoRow('Can receive new data from parent'),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.yellow.shade300),
                      ),
                      child: const Text(
                        '💡 Click "Rebuild" button above to see updates!',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Example Use Cases with Interactive Visual
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Perfect for:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Text, Icons, Images, Layouts',
                    style: TextStyle(fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  // Visual representation of static elements
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.text_fields,
                        color: Colors.green.shade400,
                        size: 16,
                      ),
                      Icon(Icons.image, color: Colors.green.shade400, size: 16),
                      Icon(
                        Icons.view_column,
                        color: Colors.green.shade400,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Extra bottom padding
          ],
        ),
      ),
    );
  }

  // Helper method to create info rows with visual indicators
  Widget _buildInfoRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, color: Colors.blue.shade300, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.replaceFirst('• ', ''),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================
// STATEFUL WIDGET EXAMPLE (RIGHT HALF)
// ===============================================

/// STATEFUL WIDGET - Content can change over time
///
/// Key characteristics:
/// - Mutable (can change)
/// - Has setState() method to trigger rebuilds
/// - Build method called multiple times
/// - Can store and modify data
/// - Used for interactive content
class StatefulWidgetExample extends StatefulWidget {
  const StatefulWidgetExample({super.key});

  @override
  State<StatefulWidgetExample> createState() => _StatefulWidgetExampleState();
}

class _StatefulWidgetExampleState extends State<StatefulWidgetExample> {
  // STATE VARIABLES - These can change over time
  int _counter = 0;
  bool _isFavorite = false;
  String _currentMessage = 'Hello!';
  Color _containerColor = Colors.red.shade100;

  // List of messages to cycle through
  final List<String> _messages = [
    'Hello!',
    'How are you?',
    'This is dynamic!',
    'State changed!',
    'Flutter rocks!',
  ];

  // METHOD to increment counter
  void _incrementCounter() {
    setState(() {
      // setState() tells Flutter to rebuild this widget
      _counter++;
      print('Counter incremented to $_counter');
    });
  }

  // METHOD to toggle favorite status
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      print('Favorite toggled to $_isFavorite');
    });
  }

  // METHOD to change message
  void _changeMessage() {
    setState(() {
      // Get next message in the list
      int currentIndex = _messages.indexOf(_currentMessage);
      int nextIndex = (currentIndex + 1) % _messages.length;
      _currentMessage = _messages[nextIndex];

      // Also change container color
      _containerColor = _containerColor == Colors.red.shade100
          ? Colors.purple.shade100
          : Colors.red.shade100;

      print('Message changed to $_currentMessage');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This build method is called EVERY TIME setState() is called
    print('StatefulWidget build() called - Counter: $_counter');

    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'STATEFUL WIDGET',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Dynamic Content Examples
            Icon(Icons.refresh, size: 50, color: Colors.red.shade600),

            const SizedBox(height: 12),

            const Text(
              'Interactive Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Counter Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Counter Example:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_counter',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      onPressed: _incrementCounter,
                      child: const Text('Increment'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Dynamic Message Section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _containerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _currentMessage,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: _changeMessage,
                    child: const Text('Change Message'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Favorite Toggle Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Favorite: '),
                IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey,
                    size: 28,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Information
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Column(
                children: [
                  Text(
                    'Perfect for:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Forms, Counters, Animations,\nUser Interactions',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Extra bottom padding
          ],
        ),
      ),
    );
  }
}

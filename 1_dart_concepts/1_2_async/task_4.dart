import 'dart:isolate';
import 'dart:math';

/// Message wrapper for isolate communication
class IsolateMessage {
  final int start;
  final int end;
  final SendPort sendPort;

  IsolateMessage(this.start, this.end, this.sendPort);
}

/// Worker isolate function: calculate sum of primes in [start, end].
void primeWorker(IsolateMessage message) {
  final sum = _sumOfPrimes(message.start, message.end);
  message.sendPort.send(sum);
}

/// Check if a number is prime
bool _isPrime(int n) {
  if (n < 2) return false;
  if (n == 2) return true;
  if (n % 2 == 0) return false;
  for (int i = 3; i <= sqrt(n).toInt(); i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

/// Sum of primes in a range
int _sumOfPrimes(int start, int end) {
  int sum = 0;
  for (int i = start; i <= end; i++) {
    if (_isPrime(i)) sum += i;
  }
  return sum;
}

Future<int> calculatePrimeSum(int n, {int isolatesCount = 4}) async {
  final ReceivePort receivePort = ReceivePort();
  final int chunkSize = (n / isolatesCount).ceil();

  // Spawn isolates
  for (int i = 0; i < isolatesCount; i++) {
    final int start = i * chunkSize + 1;
    final int end = (i + 1) * chunkSize;
    if (start > n) break;
    Isolate.spawn(
      primeWorker,
      IsolateMessage(start, end > n ? n : end, receivePort.sendPort),
    );
  }

  // Collect results
  int totalSum = 0;
  int received = 0;
  await for (final msg in receivePort) {
    totalSum += msg as int;
    received++;
    if (received == isolatesCount || received * chunkSize >= n) {
      receivePort.close();
      break;
    }
  }

  return totalSum;
}

Future<void> main() async {
  // Write a program calculating a sum of all prime numbers from 1 to N using
  // [Isolate]s to speed up the algorithm.
  const int N = 100000;
  print("Calculating sum of primes up to $N ...");

  final stopwatch = Stopwatch()..start();
  try {
    final result = await calculatePrimeSum(N, isolatesCount: 250);
    print("Sum of primes up to $N = $result");
  } catch (e) {
    print("Error: $e");
  }
  stopwatch.stop();

  print("Time taken: ${stopwatch.elapsedMilliseconds} ms");
}


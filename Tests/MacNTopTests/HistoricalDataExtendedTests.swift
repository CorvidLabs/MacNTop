import Foundation
import Testing
@testable import MacNTop

// MARK: - HistoricalData Extended Tests

@Suite("HistoricalData Extended")
struct HistoricalDataExtendedTests {
    @Test("Clear removes all values")
    func clearRemovesAll() {
        var history = HistoricalData<Int>(capacity: 5)
        history.add(1)
        history.add(2)
        history.add(3)
        history.clear()

        #expect(history.values.isEmpty)
        #expect(history.latest == nil)
        #expect(history.storedCount == 0)
        #expect(history.isEmpty == true)
    }

    @Test("isEmpty returns true for new buffer")
    func isEmptyOnNew() {
        let history = HistoricalData<Int>(capacity: 5)
        #expect(history.isEmpty == true)
    }

    @Test("isEmpty returns false after adding a value")
    func isEmptyAfterAdd() {
        var history = HistoricalData<Int>(capacity: 5)
        history.add(42)
        #expect(history.isEmpty == false)
    }

    @Test("storedCount tracks number of values")
    func storedCountTracking() {
        var history = HistoricalData<Int>(capacity: 10)
        #expect(history.storedCount == 0)

        history.add(1)
        #expect(history.storedCount == 1)

        history.add(2)
        history.add(3)
        #expect(history.storedCount == 3)
    }

    @Test("storedCount caps at capacity")
    func storedCountCapsAtCapacity() {
        var history = HistoricalData<Int>(capacity: 3)
        history.add(1)
        history.add(2)
        history.add(3)
        #expect(history.storedCount == 3)

        history.add(4)
        #expect(history.storedCount == 3)

        history.add(5)
        #expect(history.storedCount == 3)
    }

    @Test("Ring buffer wrapping preserves chronological order")
    func ringBufferWrapping() {
        var history = HistoricalData<Int>(capacity: 3)
        history.add(1)
        history.add(2)
        history.add(3)
        // Buffer is now full: [1, 2, 3], head at 0
        history.add(4)
        // Should now be [2, 3, 4] in chronological order
        #expect(history.values == [2, 3, 4])

        history.add(5)
        #expect(history.values == [3, 4, 5])

        history.add(6)
        #expect(history.values == [4, 5, 6])

        // Wrap fully around
        history.add(7)
        #expect(history.values == [5, 6, 7])
    }

    @Test("Latest value after wrapping")
    func latestAfterWrapping() {
        var history = HistoricalData<Int>(capacity: 3)
        history.add(10)
        history.add(20)
        history.add(30)
        history.add(40)
        history.add(50)

        #expect(history.latest == 50)
    }

    @Test("Capacity of 1 always holds single latest value")
    func capacityOfOne() {
        var history = HistoricalData<Int>(capacity: 1)

        history.add(100)
        #expect(history.values == [100])
        #expect(history.latest == 100)
        #expect(history.storedCount == 1)

        history.add(200)
        #expect(history.values == [200])
        #expect(history.latest == 200)
        #expect(history.storedCount == 1)

        history.add(300)
        #expect(history.values == [300])
        #expect(history.latest == 300)
    }

    @Test("Large capacity fills correctly")
    func largeCapacity() {
        var history = HistoricalData<Int>(capacity: 1000)
        for i in 0..<500 {
            history.add(i)
        }
        #expect(history.storedCount == 500)
        #expect(history.values.count == 500)
        #expect(history.latest == 499)
        #expect(history.values.first == 0)
    }

    @Test("Large capacity wraps correctly")
    func largeCapacityWrapping() {
        var history = HistoricalData<Int>(capacity: 100)
        for i in 0..<250 {
            history.add(i)
        }
        #expect(history.storedCount == 100)
        #expect(history.values.count == 100)
        #expect(history.latest == 249)
        // Oldest should be 250 - 100 = 150
        #expect(history.values.first == 150)
        #expect(history.values.last == 249)
    }

    @Test("Clear then reuse works correctly")
    func clearAndReuse() {
        var history = HistoricalData<Int>(capacity: 5)
        history.add(1)
        history.add(2)
        history.add(3)
        history.clear()

        history.add(10)
        history.add(20)
        #expect(history.values == [10, 20])
        #expect(history.storedCount == 2)
        #expect(history.latest == 20)
    }

    @Test("Values returns empty array for empty buffer")
    func valuesEmptyBuffer() {
        let history = HistoricalData<Int>(capacity: 5)
        #expect(history.values == [])
    }
}

// MARK: - HistoricalData Double Extension Tests

@Suite("HistoricalData Double Statistics")
struct HistoricalDataDoubleTests {
    @Test("Minimum value")
    func minimumValue() {
        var history = HistoricalData<Double>(capacity: 10)
        history.add(5.0)
        history.add(2.0)
        history.add(8.0)
        history.add(1.5)
        history.add(3.0)

        #expect(history.minimum == 1.5)
    }

    @Test("Maximum value")
    func maximumValue() {
        var history = HistoricalData<Double>(capacity: 10)
        history.add(5.0)
        history.add(2.0)
        history.add(8.0)
        history.add(1.5)
        history.add(3.0)

        #expect(history.maximum == 8.0)
    }

    @Test("Average value")
    func averageValue() {
        var history = HistoricalData<Double>(capacity: 10)
        history.add(10.0)
        history.add(20.0)
        history.add(30.0)

        #expect(history.average == 20.0)
    }

    @Test("Statistics on empty buffer return zero")
    func statisticsOnEmpty() {
        let history = HistoricalData<Double>(capacity: 5)
        #expect(history.minimum == 0)
        #expect(history.maximum == 0)
        #expect(history.average == 0)
    }

    @Test("Statistics with single value")
    func statisticsSingleValue() {
        var history = HistoricalData<Double>(capacity: 5)
        history.add(42.0)

        #expect(history.minimum == 42.0)
        #expect(history.maximum == 42.0)
        #expect(history.average == 42.0)
    }

    @Test("Statistics after wrapping")
    func statisticsAfterWrapping() {
        var history = HistoricalData<Double>(capacity: 3)
        history.add(100.0)
        history.add(200.0)
        history.add(300.0)
        history.add(10.0)  // Pushes out 100.0
        history.add(20.0)  // Pushes out 200.0

        // Buffer should contain [300, 10, 20]
        #expect(history.minimum == 10.0)
        #expect(history.maximum == 300.0)
        // Average: (300 + 10 + 20) / 3 = 110.0
        #expect(history.average == 110.0)
    }

    @Test("Average with uniform values")
    func averageUniform() {
        var history = HistoricalData<Double>(capacity: 5)
        history.add(7.0)
        history.add(7.0)
        history.add(7.0)

        #expect(history.average == 7.0)
    }

    @Test("Min and max with negative values")
    func negativeValues() {
        var history = HistoricalData<Double>(capacity: 5)
        history.add(-10.0)
        history.add(0.0)
        history.add(10.0)

        #expect(history.minimum == -10.0)
        #expect(history.maximum == 10.0)
        #expect(history.average == 0.0)
    }
}

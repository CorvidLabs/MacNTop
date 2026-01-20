import Foundation

/// A ring buffer for storing historical metric values for graphing.
public struct HistoricalData<Value: Sendable>: Sendable {
    private var buffer: [Value]
    private var head: Int
    private let capacity: Int
    private var count: Int

    /// Creates a new historical data buffer with the specified capacity.
    /// - Parameter capacity: Maximum number of samples to store.
    public init(capacity: Int) {
        precondition(capacity > 0, "Capacity must be positive")
        self.capacity = capacity
        self.buffer = []
        self.buffer.reserveCapacity(capacity)
        self.head = 0
        self.count = 0
    }

    /// Adds a new value to the buffer.
    /// - Parameter value: The value to add.
    public mutating func add(_ value: Value) {
        if buffer.count < capacity {
            buffer.append(value)
            count = buffer.count
        } else {
            buffer[head] = value
        }
        head = (head + 1) % capacity
    }

    /// Returns all values in chronological order (oldest to newest).
    public var values: [Value] {
        guard !buffer.isEmpty else { return [] }

        if buffer.count < capacity {
            return buffer
        }

        var result: [Value] = []
        result.reserveCapacity(capacity)

        for i in 0..<capacity {
            let index = (head + i) % capacity
            result.append(buffer[index])
        }

        return result
    }

    /// The number of stored values.
    public var storedCount: Int {
        count
    }

    /// Whether the buffer is empty.
    public var isEmpty: Bool {
        buffer.isEmpty
    }

    /// The most recent value, if any.
    public var latest: Value? {
        guard !buffer.isEmpty else { return nil }
        let index = (head - 1 + capacity) % capacity
        return buffer.count < capacity ? buffer.last : buffer[index]
    }

    /// Clears all stored values.
    public mutating func clear() {
        buffer.removeAll(keepingCapacity: true)
        head = 0
        count = 0
    }
}

extension HistoricalData where Value == Double {
    /// Minimum value in the buffer.
    public var minimum: Double {
        values.min() ?? 0
    }

    /// Maximum value in the buffer.
    public var maximum: Double {
        values.max() ?? 0
    }

    /// Average of all values.
    public var average: Double {
        let vals = values
        guard !vals.isEmpty else { return 0 }
        return vals.reduce(0, +) / Double(vals.count)
    }
}

//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDBCipher
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct ExperienceUpgradeRecord: SDSRecord {
    public var tableMetadata: SDSTableMetadata {
        return ExperienceUpgradeSerializer.table
    }

    public static let databaseTableName: String = ExperienceUpgradeSerializer.table.tableName

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
    }

    public static func columnName(_ column: ExperienceUpgradeRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        return fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(experienceUpgradeColumn column: ExperienceUpgradeRecord.CodingKeys) {
        appendLiteral(ExperienceUpgradeRecord.columnName(column))
    }
    mutating func appendInterpolation(experienceUpgradeColumnFullyQualified column: ExperienceUpgradeRecord.CodingKeys) {
        appendLiteral(ExperienceUpgradeRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension ExperienceUpgrade {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: ExperienceUpgradeRecord) throws -> ExperienceUpgrade {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .experienceUpgrade:

            let uniqueId: String = record.uniqueId

            return ExperienceUpgrade(uniqueId: uniqueId)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension ExperienceUpgrade: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return ExperienceUpgradeSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        return try serializer.asRecord()
    }
}

// MARK: - Table Metadata

extension ExperienceUpgradeSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int, columnIndex: 0)
    static let idColumn = SDSColumnMetadata(columnName: "id", columnType: .primaryKey, columnIndex: 1)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, columnIndex: 2)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(tableName: "model_ExperienceUpgrade", columns: [
        recordTypeColumn,
        idColumn,
        uniqueIdColumn
        ])
}

// MARK: - Save/Remove/Update

@objc
extension ExperienceUpgrade {
    public func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // This method is private; we should never use it directly.
    // Instead, use anyUpdate(transaction:block:), so that we
    // use the "update with" pattern.
    private func anyUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    public func anyUpsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .upsert, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    public func anyUpdate(transaction: SDSAnyWriteTransaction, block: (ExperienceUpgrade) -> Void) {
        guard let uniqueId = uniqueId else {
            owsFailDebug("Missing uniqueId.")
            return
        }

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        block(dbCopy)

        dbCopy.anyUpdate(transaction: transaction)
    }

    public func anyRemove(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            remove(with: ydbTransaction)
        case .grdbWrite(let grdbTransaction):
            do {
                let record = try asRecord()
                record.sdsRemove(transaction: grdbTransaction)
            } catch {
                owsFail("Remove failed: \(error)")
            }
        }
    }

    public func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    public func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let uniqueId = self.uniqueId else {
            owsFailDebug("uniqueId was unexpectedly nil")
            return
        }

        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - ExperienceUpgradeCursor

@objc
public class ExperienceUpgradeCursor: NSObject {
    private let cursor: RecordCursor<ExperienceUpgradeRecord>?

    init(cursor: RecordCursor<ExperienceUpgradeRecord>?) {
        self.cursor = cursor
    }

    public func next() throws -> ExperienceUpgrade? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try ExperienceUpgrade.fromRecord(record)
    }

    public func all() throws -> [ExperienceUpgrade] {
        var result = [ExperienceUpgrade]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
extension ExperienceUpgrade {
    public class func grdbFetchCursor(transaction: GRDBReadTransaction) -> ExperienceUpgradeCursor {
        let database = transaction.database
        do {
            let cursor = try ExperienceUpgradeRecord.fetchCursor(database)
            return ExperienceUpgradeCursor(cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return ExperienceUpgradeCursor(cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    public class func anyFetch(uniqueId: String,
                               transaction: SDSAnyReadTransaction) -> ExperienceUpgrade? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ExperienceUpgrade.fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(ExperienceUpgradeRecord.databaseTableName) WHERE \(experienceUpgradeColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    // Traversal aborts if the visitor returns false.
    public class func anyVisitAll(transaction: SDSAnyReadTransaction, visitor: @escaping (ExperienceUpgrade) -> Bool) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            ExperienceUpgrade.enumerateCollectionObjects(with: ydbTransaction) { (object, stop) in
                guard let value = object as? ExperienceUpgrade else {
                    owsFailDebug("unexpected object: \(type(of: object))")
                    return
                }
                guard visitor(value) else {
                    stop.pointee = true
                    return
                }
            }
        case .grdbRead(let grdbTransaction):
            do {
                let cursor = ExperienceUpgrade.grdbFetchCursor(transaction: grdbTransaction)
                while let value = try cursor.next() {
                    guard visitor(value) else {
                        return
                    }
                }
            } catch let error as NSError {
                owsFailDebug("Couldn't fetch models: \(error)")
            }
        }
    }

    // Does not order the results.
    public class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [ExperienceUpgrade] {
        var result = [ExperienceUpgrade]()
        anyVisitAll(transaction: transaction) { (model) in
            result.append(model)
            return true
        }
        return result
    }
}

// MARK: - Swift Fetch

extension ExperienceUpgrade {
    public class func grdbFetchCursor(sql: String,
                                      arguments: [DatabaseValueConvertible]?,
                                      transaction: GRDBReadTransaction) -> ExperienceUpgradeCursor {
        var statementArguments: StatementArguments?
        if let arguments = arguments {
            guard let statementArgs = StatementArguments(arguments) else {
                owsFailDebug("Could not convert arguments.")
                return ExperienceUpgradeCursor(cursor: nil)
            }
            statementArguments = statementArgs
        }
        let database = transaction.database
        do {
            let statement: SelectStatement = try database.cachedSelectStatement(sql: sql)
            let cursor = try ExperienceUpgradeRecord.fetchCursor(statement, arguments: statementArguments)
            return ExperienceUpgradeCursor(cursor: cursor)
        } catch {
            Logger.error("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return ExperienceUpgradeCursor(cursor: nil)
        }
    }

    public class func grdbFetchOne(sql: String,
                                   arguments: StatementArguments,
                                   transaction: GRDBReadTransaction) -> ExperienceUpgrade? {
        assert(sql.count > 0)

        do {
            guard let record = try ExperienceUpgradeRecord.fetchOne(transaction.database, sql: sql, arguments: arguments) else {
                return nil
            }

            return try ExperienceUpgrade.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class ExperienceUpgradeSerializer: SDSSerializer {

    private let model: ExperienceUpgrade
    public required init(model: ExperienceUpgrade) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = nil

        let recordType: SDSRecordType = .experienceUpgrade
        guard let uniqueId: String = model.uniqueId else {
            owsFailDebug("Missing uniqueId.")
            throw SDSError.missingRequiredField
        }

        return ExperienceUpgradeRecord(id: id, recordType: recordType, uniqueId: uniqueId)
    }
}

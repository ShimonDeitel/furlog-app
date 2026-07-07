import XCTest
@testable import Furlog

final class FurlogTests: XCTestCase {
    var store: FurlogStore!

    override func setUp() {
        super.setUp()
        store = FurlogStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.sessions.count, FurlogStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.sessions.count
        let added = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.sessions.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.sessions.count < FurlogStore.freeTierLimit {
            _ = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        }
        let blocked = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.sessions.count < FurlogStore.freeTierLimit {
            _ = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        }
        let allowed = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.sessions.count < FurlogStore.freeTierLimit {
            _ = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(GroomingSession(petName: "P", groomingType: "G"), isPro: false)
        let before = store.sessions.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.sessions.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.sessions.count
        let reloaded = FurlogStore()
        XCTAssertEqual(reloaded.sessions.count, count)
    }
}

import Array "mo:stdlib/array";
import Types "./types";

type Entry = Types.Entry;

actor {

    var entries: [Entry] = [];
    var uniqueId: Nat = 0;

    public func newEntry(author0: Text, content0: Text): async () {
        uniqueId := uniqueId + 1;
        let entry: Entry = {
            id = uniqueId;
            author = author0;
            content = content0;
        };
        entries := Array.append<Entry>(entries, [entry]);
    };

    public query func get(id0: Nat): async ?Entry {
        func isEq(entry: Entry): Bool {
            entry.id == id0
        };
        Array.find<Entry>(isEq, entries)
    };

};

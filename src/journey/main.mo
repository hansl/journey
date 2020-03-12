import Array "mo:stdlib/array";
import Types "./types";

type Entry = Types.Entry;

actor {

    var entries: [Entry] = [];
    var uniqueId: Nat = 0;

    public func newEntry(author0: Text, content0: Text): async Nat {
        uniqueId := uniqueId + 1;
        let entry: Entry = {
            id = uniqueId;
            author = author0;
            content = content0;
        };
        entries := Array.append<Entry>(entries, [entry]);

        uniqueId
    };

    public query func list(max: Nat): async [Entry] {
        var m = max;
        if (entries.len() == 0) {
            return [];
        };
        if (m > entries.len()) {
            m := entries.len();
        };

        func gen(i: Nat): Entry { entries[entries.len() - i - 1] };
        Array.tabulate<Entry>(m, gen)
    };

    public query func get(id0: Nat): async ?Entry {
        func isEq(entry: Entry): Bool {
            entry.id == id0
        };
        Array.find<Entry>(isEq, entries)
    };

};

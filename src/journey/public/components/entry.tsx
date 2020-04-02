/**
 * Components for entries;
 *    EntryList
 *    EntrySummary
 *    Entry
 */

import journey from 'ic:canisters/journey';
import * as React from 'react';
import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';

interface EntryIdl {
  author: string;
  content: string;
  id: { toNumber(): number };
}

export function Entry() {
  let { id } = useParams();
  const [entry, setEntry] = useState({} as EntryIdl);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let natId = parseInt('' + id, 10);
    if (!isFinite(natId)) {
      // Invalid string passed as number.
      throw new Error('Invalid ID: ' + JSON.stringify(id));
    }

    journey.get(natId).then((optEntry: EntryIdl[]) => {
      let [entry] = optEntry;
      console.log(optEntry);
      if (!entry) {
        // TODO: move this to a 404/403.
        throw new Error('ID not found.');
      } else {
        setEntry(entry);
        setLoading(false);
      }
    })
  });

  if (loading) {
    return (<progress />)
  } else {
    return (
      <div>
        <section>{entry.content}</section>
        By <span>{entry.author}</span>. <Link to="/">back</Link>
      </div>
    );
  }
}

export function EntrySummary(props: { entry: EntryIdl }) {
  const entry = props.entry;
  const indexOfBreak = entry.content.indexOf('\n');

  return (
    <div>
      <section>
        {entry.content.slice(0, indexOfBreak > 0 ? indexOfBreak : undefined)}
      </section>
      By <span>{entry.author}</span>. <Link to={'/entry/' + entry.id}>view</Link>
    </div>
  );
}

export function EntryList() {
  const [entryList, setEntryList] = useState([] as EntryIdl[]);

  useEffect(() => {
    journey.list(10).then((list: EntryIdl[]) => setEntryList(list));
  });

  return (
    <ol>
      {entryList.map(entry => {
        return (<li><EntrySummary entry={entry} /></li>);
      })}
    </ol>
  );
}

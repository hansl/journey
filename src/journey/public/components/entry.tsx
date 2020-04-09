/**
 * Components for entries;
 *    NewEntry
 *    EntryList
 *    EntrySummary
 *    Entry
 */

import journey from 'ic:canisters/journey';
import * as React from 'react';
import { useEffect, useState } from 'react';
import { Link, Redirect, useParams } from 'react-router-dom';

interface UserIdl {
  id: { toNumber(): number };
  name: string;
  description: string;
}

interface EntryIdl {
  author: [UserIdl?];
  content: string;
  title: string;
  id: { toNumber(): number };
}

export function NewEntry() {
  const [content, setContent] = useState('');
  const [title, setTitle] = useState('New Entry');
  const [done, setDone] = useState(false);
  const [saving, setSaving] = useState(false);
  const author = 1;

  async function submit() {
    setSaving(true);

    await journey.newEntry(author, title, content);
    setDone(true);
  }

  if (done) {
    return (<Redirect to='/' />)
  }
  if (saving) {
    return (<progress />);
  }

  return (
    <div>
      <form name="new-entry" onSubmit={() => submit()}>
        <div>Title: <input type="text" value={title} onChange={ev => setTitle(ev.target.value)} /></div>
        <div>Content:</div>
        <div><textarea value={content} onChange={ev => setContent(ev.target.value)} /></div>
        <div><button type="submit">Submit</button></div>
      </form>
      <div>
        <Link to="/">cancel</Link>
      </div>
    </div>
  );
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
        <section><h1>{entry.title}</h1></section>
        <section>{entry.content}</section>
        By <span>{entry.author[0]?.name}</span>. <Link to="/">back</Link>
      </div>
    );
  }
}

export function EntrySummary(props: { entry: EntryIdl }) {
  const entry = props.entry;
  const indexOfBreak = entry.content.indexOf('\n');

  return (
    <div>
      <h1>{entry.title}</h1>
      <section>
        {entry.content.slice(0, indexOfBreak > 0 ? indexOfBreak : undefined)}
      </section>
      By <span>{entry.author[0]?.name}</span>. <Link to={'/entry/' + entry.id}>view</Link>
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

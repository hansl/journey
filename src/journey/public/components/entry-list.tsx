import journey from 'ic:canisters/journey';
import * as React from 'react';
import { useEffect, useState } from 'react';

export function EntryList() {
  const [entry, setEntry] = useState([]);

  useEffect(() => {
    journey.list(10).then((list: any) => setEntry(list));
  });

  return (
    <div>{JSON.stringify(entry)}</div>
  );
}

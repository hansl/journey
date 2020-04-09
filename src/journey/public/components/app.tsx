import * as React from 'react';
import { EntryList, Entry, NewEntry } from './entry';
import {
  HashRouter as Router,
  Switch,
  Route, Link,
} from 'react-router-dom';

export function JourneyApp() {
  return <Router>
    <Switch>
      <Route path="/entry/:id" children={<Entry />} />
      <Route path="/new/"><NewEntry /></Route>
      <Route path="/">
        <EntryList />
        <Link to="/new">New Entry</Link>
      </Route>
    </Switch>
  </Router>;
}

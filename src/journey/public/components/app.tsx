import * as React from 'react';
import { EntryList, Entry } from './entry';
import {
  HashRouter as Router,
  Switch,
  Route,
} from 'react-router-dom';

export function JourneyApp() {
  return <Router>
    <Switch>
      <Route path="/entry/:id" children={<Entry />} />
      <Route path="/">
        <EntryList />
      </Route>
    </Switch>
  </Router>;
}

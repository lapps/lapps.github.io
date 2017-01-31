---
layout: slate
title: Language Application Grid
---

# OAuth Authentication

To retrieve documents from the LDC's Gigaword corpus.

1. Visit [https://grid.anc.org:9443/ldc-authorize/](https://grid.anc.org:9443/ldc-authorize/) to obtain an OAuth token. When a user clicks the green *Authorize* button they will be forwarded to a LDC login page. Once the user has been authenticated by the LDC they will be redirected back to the *ldc-authorize* service with an OAuth token that is valid for six hours (subject to change by the LDC).
1. Users must manually copy/paste this OAuth token into a *OAuth Key Provider* tool in the Galaxy interface.


## Implementation Details

The service classes (`ServiceClient` and `DataSourceClient`) have a `setToken(String)` method to set the OAuth token to be used when requesting documents.  The `setToken` method is provided by the `AbstractClient` base class and simply sets the *Authorization* HTTP header is requests sent to the LDC server.

```
Authorization: bearer 0123456789deadbeef
```

## To Do

Ideally, the LDC authentication service would redirect back to Galaxy directly so the user does not have to copy/paste the OAuth token.  This would also permit Galaxy to request refresh tokens as needed (and once the LDC supports refresh tokens).  To support this the Galaxy code base needs to be modified to provide an URL endpoint that the token provider can *POST* the token to.



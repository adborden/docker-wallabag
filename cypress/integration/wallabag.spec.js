function waitForUrl (url, cb) {
  console.log('waitfor');
  cy.request({
    url,
    failOnStatusCode: false,
    timeout: 3000,
  }).then((response) => {
    console.log({response});
    if (response.status === 200) {
      cb();
      return;
    }

    cy.wait(1000);
    waitForUrl(url, cb);
  });
}

describe('Wait for wallabag', { defaultCommandTimeout: 60 * 1000 }, () => {
  it('ok', (done) => {
    setImmediate(() => waitForUrl('/api/version.json', done));
  });
});

describe('Wallabag routes', () => {
  describe('/', () => {
    it('redirects to /login', () => {
      cy.request({
        url: '/',
        followRedirect: false,
      }).should((response) => {
        expect(response.status).to.equal(302);
        expect(response.redirectedToUrl).to.equal('http://localhost:8080/login');
      });
    });
  });

  describe('/login', () => {
    beforeEach(() => {
      cy.visit('/login');
    });

    it('has a title', () => {
      cy.title().should('eq', 'Welcome to wallabag! – wallabag');
    });

    it('has a login button', () => {
      cy.contains('Login');
    });

    it('does not have a register button', () => {
      cy.get('Register').should('not.exist');
    });
  });
});

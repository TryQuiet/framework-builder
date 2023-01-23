const { app } = require('electron')

const LevelDOWN = require('leveldown');

const instance = LevelDOWN('dummy');
instance.open(() => {
    console.log('on db open');
});

app.quit();

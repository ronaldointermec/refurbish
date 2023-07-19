(async () => {
    const { exec } = require('child_process');

    await new Promise((resolve, reject) => {

        const dbcreate = exec(
            'sequelize db:create',
            { env: process.env },
            (err, stdout, stderr) => {

                const migrate = exec(
                    'sequelize db:migrate',
                    { env: process.env },
                    (err, stdout, stderr) => {
                        resolve();

                    }
                );
                // resolve();
                migrate.stdout.on('data', (data) => {
                    console.log(data);
                    if (data.indexOf('No migrations were executed, database schema was already up to date.') !== -1) {
                        migrate.kill();
                    }
                });


            }
        );

        // Listen for the console.log message and kill the process to proceed to the next step in the npm script

        dbcreate.stdout.on('data', (data) => {
            console.log(data);
            if (data.indexOf('No migrations were executed, database schema was already up to date.') !== -1) {
                dbcreate.kill();
            }
        });

    });
})();
<?php

namespace App\Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Process\Process;

class NginxReloadCommand extends ContainerAwareCommand
{
    protected function configure()
    {
        $this->setName('nginx:reload');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $availDir = '/etc/nginx/sites-available/';
        $enabledDir = '/etc/nginx/sites-enabled/';

        $available = scandir($availDir, SCANDIR_SORT_ASCENDING);
        $enabled = scandir($enabledDir, SCANDIR_SORT_ASCENDING);

        $diff = array_diff($available, $enabled);

        foreach ($diff as $file) {
            copy($availDir.$file, $enabledDir.$file);
        }
        $output->writeln(count($diff).' new configs have been added.');
        $process = new Process('nginx -t');
        $process->run();
        if ($process->isSuccessful()) {
            $output->writeln('Config is valid, reloading.');
            $process = new Process('service nginx reload');
            $process->run();
        } else {
            $output->writeln('<error>Config is invalid. Reverting.</error>');
            foreach ($diff as $file) {
                unlink($enabledDir.$file);
            }
        }

    }

}

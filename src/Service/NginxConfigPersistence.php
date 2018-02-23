<?php

namespace App\Service;

class NginxConfigPersistence
{
    protected $nginxPath = '/etc/nginx/';
    protected $certTypes = [
        'fullchain' => 'fullchain.pem',
        'key'       => 'privkey.pem'
    ];

    public function createConfig(string $templatePath, string $domain, string $directory): void
    {
        $config = file_get_contents($templatePath);
        $config = str_replace('<%domain%>', $domain, $config);
        $config = str_replace('<%files%>', $directory, $config);
        file_put_contents($this->nginxPath.'sites-available/'.$directory, $config);
    }

    public function saveCertificate(string $file, string $directory, string $type): void
    {
        if (!array_key_exists($type, $this->certTypes)) {
            throw new \InvalidArgumentException('Wrong certificate type');
        }
        file_put_contents($this->nginxPath.$directory.'/'.$this->certTypes[$type], $file);
    }
}

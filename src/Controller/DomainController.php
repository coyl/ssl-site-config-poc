<?php

namespace App\Controller;

use App\Service\NginxConfigPersistence;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class DomainController extends AbstractController
{
    public function configure(Request $request, NginxConfigPersistence $configs): Response
    {
        $domain = strtolower($request->get('domain'));
        $domain = preg_replace('/[^\.a-z-]/', '', $domain);
        $filesPart = preg_replace('/[^a-z]/', '', $domain);

        $chain = $request->files->get('chain');
        $key = $request->files->get('key');

        if ($key && $chain) {
            $configs->createConfig('../assets/domain-config.conf', $domain, $filesPart);
            $configs->saveCertificate($chain, $filesPart, 'fullchain');
            $configs->saveCertificate($key, $filesPart, 'key');
        }
        return $this->render('index.html.twig');
    }
}

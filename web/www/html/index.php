<html>
  <head>
    <title>Hello there!</title>
  </head>
  <body>
    <img src="image/Container-255x115.png" alt="Azure Container Service Logo" style="float:right"/>
    <h1>Hello and welcome to the PHP Web application</h1>
    <p>Host: <?php echo gethostname() ?></p>
    <?php
       // Sleep to make the script take enough time to fail the CI test.
       // usleep(40000);

       $service_url = 'http://rest-demo-azure.marathon.mesos:8080/JerseyHelloWorld/rest/helloworld';
       $curl = curl_init($service_url);
       curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
       $curl_response = curl_exec($curl);
       if ($curl_response === false) {
         $info = curl_getinfo($curl);
         curl_close($curl);
         die('error occured during curl exec. Additional info: ' . var_export($info));
       }

       curl_close($curl);
    ?>
    <h1>Rest API Response</h1>
    <?php echo $curl_response ?>

  </body>
</html>
